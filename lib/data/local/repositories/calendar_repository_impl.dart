import 'package:isar_community/isar.dart';

import '../../../core/utils/date_helpers.dart';
import '../../../domain/entities/calendar_day_entity.dart';
import '../../../domain/repositories/calendar_repository.dart';
import '../../models/calendar_day_model.dart';
import '../database/company_scope.dart';
import '../database/isar_database.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  Future<Isar> get _db async => await IsarDatabase.instance;

  @override
  Future<List<CalendarDayEntity>> getBetween(DateTime from, DateTime to) async {
    final isar = await _db;
    final companyId = await CompanyScope.activeId(isar);

    // إدخالات الجهة والإدخالات العامة معاً: العام يسري ما لم تخالفه الجهة،
    // والترجيح بينهما شأن `EffectiveDayResolver` لا الاستعلام.
    final models = await isar.calendarDayModels
        .filter()
        .dateBetween(DateHelpers.startOfDay(from), DateHelpers.endOfDay(to))
        .group((q) => q.companyIdEqualTo(companyId).or().companyIdIsNull())
        .sortByDate()
        .findAll();

    return models.map(_mapToEntity).toList();
  }

  @override
  Future<List<CalendarDayEntity>> getForDate(DateTime date) async {
    final entries = await getBetween(date, date);
    // الأخصّ أولاً حتى يكفي القارئ أخذ الأول.
    return entries..sort((a, b) {
        if (a.isWorkplaceSpecific == b.isWorkplaceSpecific) return 0;
        return a.isWorkplaceSpecific ? -1 : 1;
      });
  }

  @override
  Future<void> mark({
    required DateTime date,
    required CalendarDayKindEntity kind,
    String? note,
    bool appliesToAllCompanies = false,
  }) async {
    final isar = await _db;
    final companyId =
        appliesToAllCompanies ? null : await CompanyScope.activeId(isar);
    final day = DateHelpers.startOfDay(date);

    // تعليم اليوم مرّتين يستبدل ولا يضاعف: إدخالان لليوم نفسه بالنطاق نفسه
    // يجعلان الحاكم رهناً بترتيب الاستعلام.
    final existing = await isar.calendarDayModels
        .filter()
        .dateEqualTo(day)
        .group((q) => companyId == null
            ? q.companyIdIsNull()
            : q.companyIdEqualTo(companyId))
        .findFirst();

    final model = existing ?? (CalendarDayModel()..createdAt = DateTime.now());
    model
      ..companyId = companyId
      ..date = day
      ..kind = _mapKind(kind)
      ..note = note;

    await isar.writeTxn(() async {
      await isar.calendarDayModels.put(model);
    });
  }

  @override
  Future<void> unmark(int id) async {
    final isar = await _db;
    final companyId = await CompanyScope.activeId(isar);
    final model = await isar.calendarDayModels.get(id);

    // إدخال عام يجوز حذفه من أي جهة؛ وإدخال جهة أخرى لا.
    if (model == null) throw Exception('هذا اليوم غير موجود');
    if (model.companyId != null && model.companyId != companyId) {
      throw Exception('هذا اليوم يخص جهة عمل أخرى');
    }

    await isar.writeTxn(() async {
      await isar.calendarDayModels.delete(id);
    });
  }

  static CalendarDayKind _mapKind(CalendarDayKindEntity kind) =>
      switch (kind) {
        CalendarDayKindEntity.publicHoliday => CalendarDayKind.publicHoliday,
        CalendarDayKindEntity.workplaceHoliday =>
          CalendarDayKind.workplaceHoliday,
        CalendarDayKindEntity.specialWorkday => CalendarDayKind.specialWorkday,
      };

  static CalendarDayEntity _mapToEntity(CalendarDayModel m) =>
      CalendarDayEntity(
        id: m.id,
        companyId: m.companyId,
        date: m.date,
        kind: switch (m.kind) {
          CalendarDayKind.publicHoliday => CalendarDayKindEntity.publicHoliday,
          CalendarDayKind.workplaceHoliday =>
            CalendarDayKindEntity.workplaceHoliday,
          CalendarDayKind.specialWorkday =>
            CalendarDayKindEntity.specialWorkday,
        },
        note: m.note,
        createdAt: m.createdAt,
      );
}
