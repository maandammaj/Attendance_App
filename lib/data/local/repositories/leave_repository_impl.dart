import 'package:isar_community/isar.dart';

import '../../../core/utils/date_helpers.dart';
import '../../../domain/entities/leave_entity.dart';
import '../../../domain/repositories/leave_repository.dart';
import '../../models/company_model.dart';
import '../../models/leave_model.dart';
import '../database/company_scope.dart';
import '../database/isar_database.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  Future<Isar> get _db async => await IsarDatabase.instance;

  @override
  Future<List<LeaveEntity>> getBetween(DateTime from, DateTime to) async {
    final isar = await _db;
    return getBetweenForCompany(
        await CompanyScope.activeId(isar), from, to);
  }

  @override
  Future<List<LeaveEntity>> getBetweenForCompany(
      int companyId, DateTime from, DateTime to) async {
    final isar = await _db;

    // التقاطع لا الاحتواء: إجازة تبدأ قبل المدى وتنتهي داخله تخصّه أيضاً.
    final models = await isar.leaveModels
        .filter()
        .companyIdEqualTo(companyId)
        .fromLessThan(DateHelpers.endOfDay(to))
        .toGreaterThan(DateHelpers.startOfDay(from).subtract(
          const Duration(milliseconds: 1),
        ))
        .sortByFrom()
        .findAll();

    return models.map(_mapToEntity).toList();
  }

  @override
  Future<List<LeaveBalanceEntity>> getBalances(int year) async {
    final isar = await _db;
    final companyId = await CompanyScope.activeId(isar);
    final company = await isar.companyModels.get(companyId);
    if (company == null) throw Exception('جهة العمل غير موجودة');

    final taken = await getBetween(DateTime(year, 1, 1), DateTime(year, 12, 31));

    final used = <LeaveTypeEntity, int>{};
    for (final leave in taken) {
      // الأيام الواقعة داخل السنة وحدها: إجازة تعبر رأس السنة تُقسَّم على
      // سنتيها بدل أن تُحمَّل كاملةً على إحداهما.
      used.update(leave.type, (v) => v + _daysInYear(leave, year),
          ifAbsent: () => _daysInYear(leave, year));
    }

    final declared = {
      for (final a in company.leaveAllowances) _mapType(a.type): a.days,
    };

    // كل نوع يظهر ولو بلا رصيد مُعلَن: المستخدم يرى ما استهلك حتى مما لم
    // يحدّد له رصيداً.
    return [
      for (final type in LeaveTypeEntity.values)
        LeaveBalanceEntity(
          type: type,
          allowance: declared[type] ?? 0,
          used: used[type] ?? 0,
        ),
    ];
  }

  @override
  Future<void> add({
    required DateTime from,
    required DateTime to,
    required LeaveTypeEntity type,
    String? note,
  }) async {
    if (to.isBefore(from)) throw Exception('نهاية الإجازة قبل بدايتها');

    final isar = await _db;
    final companyId = await CompanyScope.activeId(isar);

    final model = LeaveModel()
      ..companyId = companyId
      ..from = DateHelpers.startOfDay(from)
      ..to = DateHelpers.startOfDay(to)
      ..type = _mapTypeToStored(type)
      ..note = note
      ..createdAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.leaveModels.put(model);
    });
  }

  @override
  Future<void> delete(int id) async {
    final isar = await _db;
    final companyId = await CompanyScope.activeId(isar);
    final model = await isar.leaveModels.get(id);
    CompanyScope.assertOwned(
      recordCompanyId: model?.companyId,
      activeCompanyId: companyId,
      subject: 'هذه الإجازة',
    );

    await isar.writeTxn(() async {
      await isar.leaveModels.delete(id);
    });
  }

  static int _daysInYear(LeaveEntity leave, int year) {
    final start = leave.from.isBefore(DateTime(year, 1, 1))
        ? DateTime(year, 1, 1)
        : leave.from;
    final end = leave.to.isAfter(DateTime(year, 12, 31))
        ? DateTime(year, 12, 31)
        : leave.to;
    final days = end.difference(start).inDays + 1;
    return days < 0 ? 0 : days;
  }

  static LeaveTypeEntity _mapType(LeaveTypeStored t) => switch (t) {
        LeaveTypeStored.annual => LeaveTypeEntity.annual,
        LeaveTypeStored.sick => LeaveTypeEntity.sick,
        LeaveTypeStored.emergency => LeaveTypeEntity.emergency,
        LeaveTypeStored.official => LeaveTypeEntity.official,
        LeaveTypeStored.unpaid => LeaveTypeEntity.unpaid,
        LeaveTypeStored.other => LeaveTypeEntity.other,
      };

  static LeaveTypeStored _mapTypeToStored(LeaveTypeEntity t) => switch (t) {
        LeaveTypeEntity.annual => LeaveTypeStored.annual,
        LeaveTypeEntity.sick => LeaveTypeStored.sick,
        LeaveTypeEntity.emergency => LeaveTypeStored.emergency,
        LeaveTypeEntity.official => LeaveTypeStored.official,
        LeaveTypeEntity.unpaid => LeaveTypeStored.unpaid,
        LeaveTypeEntity.other => LeaveTypeStored.other,
      };

  static LeaveEntity _mapToEntity(LeaveModel m) => LeaveEntity(
        id: m.id,
        companyId: m.companyId,
        from: m.from,
        to: m.to,
        type: _mapType(m.type),
        note: m.note,
        createdAt: m.createdAt,
      );
}
