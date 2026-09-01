import 'package:isar_community/isar.dart';

import '../../../domain/entities/company_entity.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../../domain/repositories/company_repository.dart';
import '../../models/attendance_model.dart';
import '../../models/company_model.dart';
import '../../models/profile_model.dart';
import '../database/isar_database.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  Future<Isar> get _db async => await IsarDatabase.instance;

  @override
  Future<List<CompanyEntity>> getAll({bool includeArchived = true}) async {
    final isar = await _db;
    final models = await isar.companyModels.where().findAll();
    final filtered =
        includeArchived ? models : models.where((m) => !m.isArchived).toList();
    // المؤرشفة أخيراً، ثم الأقدم أولاً حتى لا يقفز الترتيب مع كل تعديل.
    filtered.sort((a, b) {
      if (a.isArchived != b.isArchived) return a.isArchived ? 1 : -1;
      return a.createdAt.compareTo(b.createdAt);
    });
    return filtered.map(_mapToEntity).toList();
  }

  @override
  Future<CompanyEntity?> getById(int id) async {
    final isar = await _db;
    final model = await isar.companyModels.get(id);
    return model == null ? null : _mapToEntity(model);
  }

  @override
  Future<CompanyEntity?> getActive() async {
    final isar = await _db;
    final profile = await isar.profileModels.get(0);

    final active = profile?.activeCompanyId;
    if (active != null) {
      final model = await isar.companyModels.get(active);
      if (model != null) return _mapToEntity(model);
    }

    // المؤشر ضائع (حُذفت الجهة مثلاً): نرجع لأول جهة عاملة ونصحّح المؤشر.
    final fallback = await isar.companyModels
        .filter()
        .isArchivedEqualTo(false)
        .findFirst();
    if (fallback == null) return null;

    await setActive(fallback.id);
    return _mapToEntity(fallback);
  }

  @override
  Future<int> create(CompanyEntity company) async {
    final isar = await _db;
    final model = _mapToModel(company);
    late int id;

    await isar.writeTxn(() async {
      id = await isar.companyModels.put(model);

      final profile = await isar.profileModels.get(0);
      // أول جهة تصير الفعّالة: بلا ذلك يفتح التطبيق بلا جهة مختارة.
      if (profile != null && profile.activeCompanyId == null) {
        profile
          ..activeCompanyId = id
          ..updatedAt = DateTime.now();
        await isar.profileModels.put(profile);
      }
    });
    return id;
  }

  @override
  Future<void> update(CompanyEntity company) async {
    final isar = await _db;
    await isar.writeTxn(() async {
      await isar.companyModels.put(_mapToModel(company));
    });
  }

  @override
  Future<void> setActive(int companyId) async {
    final isar = await _db;
    await isar.writeTxn(() async {
      final profile = await isar.profileModels.get(0);
      if (profile == null) return;
      profile
        ..activeCompanyId = companyId
        ..updatedAt = DateTime.now();
      await isar.profileModels.put(profile);
    });
  }

  @override
  Future<void> delete(int companyId) async {
    final isar = await _db;
    await isar.writeTxn(() async {
      // سجلات الدوام تُحذف معها: بلا جهة لا معنى لها ولا يمكن حساب قيمتها.
      final records = await isar.attendanceModels
          .filter()
          .companyIdEqualTo(companyId)
          .findAll();
      await isar.attendanceModels.deleteAll(records.map((r) => r.id).toList());
      await isar.companyModels.delete(companyId);

      final profile = await isar.profileModels.get(0);
      if (profile?.activeCompanyId != companyId) return;

      final next = await isar.companyModels
          .filter()
          .isArchivedEqualTo(false)
          .findFirst();
      profile!
        ..activeCompanyId = next?.id
        ..updatedAt = DateTime.now();
      await isar.profileModels.put(profile);
    });
  }

  CompanyEntity _mapToEntity(CompanyModel m) {
    return CompanyEntity(
      id: m.id,
      name: m.name,
      jobTitle: m.jobTitle,
      baseMonthlySalary: m.baseMonthlySalary,
      hourlyRate: m.hourlyRate,
      overtimeRate: m.overtimeRate,
      workSchedule: m.workSchedule
          .map((w) => WorkDayConfigEntity(
                dayOfWeek: w.dayOfWeek,
                isWorkingDay: w.isWorkingDay,
                requiredHours: w.requiredHours,
                requiredMinutes: w.requiredMinutes,
                isHoliday: w.isHoliday,
                startTime: w.startTime,
                endTime: w.endTime,
                isCrossDay: w.isCrossDay,
              ))
          .toList(),
      adjustments: m.adjustments
          .map((a) => SalaryAdjustmentEntity(
                title: a.title,
                amount: a.amount,
                isAddition: a.isAddition,
              ))
          .toList(),
      currency: m.currency,
      employmentStartDate: m.employmentStartDate,
      colorIndex: m.colorIndex,
      isArchived: m.isArchived,
      createdAt: m.createdAt,
      updatedAt: m.updatedAt,
    );
  }

  CompanyModel _mapToModel(CompanyEntity e) {
    return CompanyModel()
      ..id = e.id == 0 ? Isar.autoIncrement : e.id
      ..name = e.name
      ..jobTitle = e.jobTitle
      ..baseMonthlySalary = e.baseMonthlySalary
      ..hourlyRate = e.hourlyRate
      ..overtimeRate = e.overtimeRate
      ..workSchedule = e.workSchedule
          .map((w) => WorkDayConfig()
            ..dayOfWeek = w.dayOfWeek
            ..isWorkingDay = w.isWorkingDay
            ..requiredHours = w.requiredHours
            ..requiredMinutes = w.requiredMinutes
            ..isHoliday = w.isHoliday
            ..startTime = w.startTime
            ..endTime = w.endTime
            ..isCrossDay = w.isCrossDay)
          .toList()
      ..adjustments = e.adjustments
          .map((a) => SalaryAdjustment()
            ..title = a.title
            ..amount = a.amount
            ..isAddition = a.isAddition)
          .toList()
      ..currency = e.currency
      ..employmentStartDate = e.employmentStartDate
      ..colorIndex = e.colorIndex
      ..isArchived = e.isArchived
      ..createdAt = e.createdAt
      ..updatedAt = DateTime.now();
  }
}
