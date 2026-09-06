import 'dart:developer' as developer;

import 'package:isar_community/isar.dart';

import '../../../core/utils/date_helpers.dart';
import '../../../domain/entities/attendance_entity.dart';
import '../../../domain/entities/company_entity.dart';
import '../../../domain/entities/overtime_policy_entity.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../../domain/repositories/attendance_repository.dart';
import '../../../domain/entities/calendar_day_entity.dart';
import '../../../domain/services/attendance_calculation_service.dart';
import '../../../domain/services/effective_day_resolver.dart';
import '../../../domain/services/session_overlap_rule.dart';
import '../../models/attendance_model.dart';
import '../../models/calendar_day_model.dart';
import '../../models/company_model.dart';
import '../../models/profile_model.dart';
import '../database/company_scope.dart';
import '../database/isar_database.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  Future<Isar> get _db async => await IsarDatabase.instance;

  /// الجهة التي تُكتب سجلات الدوام باسمها وتُقرأ بها.
  ///
  /// بلا جهة فعّالة لا يُعرف أي جدول يُطبَّق ولا أي راتب يُحتسب، فالفشل صريح
  /// بدل كتابة سجل لا معنى له.
  /// الجهة المطلوبة صراحةً، وإلا الفعّالة.
  Future<CompanyModel> _companyFor(Isar isar, int? companyId) async {
    if (companyId == null) return _activeCompany(isar);
    final company = await isar.companyModels.get(companyId);
    if (company == null) throw Exception('جهة العمل غير موجودة');
    return company;
  }

  Future<CompanyModel> _activeCompany(Isar isar) async {
    final profile = await isar.profileModels.get(0);
    final id = profile?.activeCompanyId;

    final company = id == null
        ? await isar.companyModels.filter().isArchivedEqualTo(false).findFirst()
        : await isar.companyModels.get(id);

    if (company == null) throw Exception('لم تُحدَّد جهة عمل');
    return company;
  }

  Future<int> _activeCompanyId(Isar isar) async =>
      (await _activeCompany(isar)).id;

  @override
  Future<AttendanceEntity?> getTodayRecord() async {
    final isar = await _db;
    final today = DateTime.now();
    final companyId = await _activeCompanyId(isar);

    // الجلسة المفتوحة لها الأولوية حتى لو بدأت أمس (وردية عابرة لمنتصف الليل).
    // الترشيح بالجهة إلزامي: بدونه تُعرض جلسة جهة أخرى ثم يفشل الانصراف
    // لأنه يبحث عنها في الجهة المعروضة.
    final open = await isar.attendanceModels
        .filter()
        .companyIdEqualTo(companyId)
        .isOpenEqualTo(true)
        .sortByDateDesc()
        .findFirst();
    if (open != null) return _mapToEntity(open);

    final record = await isar.attendanceModels
        .filter()
        .companyIdEqualTo(companyId)
        .dateBetween(DateHelpers.startOfDay(today), DateHelpers.endOfDay(today))
        .sortByDateDesc()
        .findFirst();

    return record == null ? null : _mapToEntity(record);
  }

  @override
  Future<List<AttendanceEntity>> getRecordsForCompany(
    int companyId,
    DateTime from,
    DateTime to,
  ) async {
    final isar = await _db;
    final records = await isar.attendanceModels
        .filter()
        .companyIdEqualTo(companyId)
        .dateBetween(from, to)
        .sortByDateDesc()
        .findAll();
    return records.map(_mapToEntity).toList();
  }

  @override
  Future<AttendanceEntity?> getAnyOpenSession() async {
    final isar = await _db;
    final record = await isar.attendanceModels
        .filter()
        .isOpenEqualTo(true)
        .sortByDateDesc()
        .findFirst();
    return record == null ? null : _mapToEntity(record);
  }

  @override
  Future<List<AttendanceEntity>> getMonthlyRecords(int year, int month) {
    return getRecordsBetween(
      DateTime(year, month, 1),
      DateHelpers.endOfMonth(DateTime(year, month, 1)),
    );
  }

  @override
  Future<List<AttendanceEntity>> getRecordsBetween(
      DateTime from, DateTime to) async {
    final isar = await _db;
    final companyId = await _activeCompanyId(isar);
    final records = await isar.attendanceModels
        .filter()
        .companyIdEqualTo(companyId)
        .dateBetween(from, to)
        .sortByDateDesc()
        .findAll();
    return records.map(_mapToEntity).toList();
  }

  /// يفتح جلسة جديدة. اليوم الواحد يقبل عدة جلسات، لكن لا جلستين مفتوحتين معاً.
  @override
  Future<void> checkIn(
    DateTime time, {
    bool isBiometricVerified = false,
    int? companyId,
  }) async {
    final isar = await _db;
    final company = await _companyFor(isar, companyId);

    final alreadyOpen = await isar.attendanceModels
        .filter()
        .isOpenEqualTo(true)
        .findFirst();
    if (alreadyOpen != null) {
      final owner = await isar.companyModels.get(alreadyOpen.companyId);
      throw Exception(owner == null
          ? 'لديك جلسة دوام مفتوحة بالفعل، سجّل الانصراف أولاً'
          : 'لديك جلسة مفتوحة في «${owner.name}» — سجّل انصرافك منها أولاً');
    }

    final companyEntity = _mapCompanyToEntity(company);
    final day = DateHelpers.startOfDay(time);
    final effective = await _effectiveConfig(isar, companyEntity, time);
    final dayConfig = effective.config;

    final record = await isar.attendanceModels
            .filter()
            .companyIdEqualTo(company.id)
            .dateBetween(day, DateHelpers.endOfDay(time))
            .findFirst() ??
        _newRecord(day, dayConfig, company.id);

    record.sessions = [
      ...record.sessions,
      WorkSession()
        ..checkIn = time
        ..isBiometricVerified = isBiometricVerified,
    ];
    record.isAbsent = false;
    _recalculate(record, companyEntity, dayConfig, effective.dayType);

    await isar.writeTxn(() async {
      await isar.attendanceModels.put(record);
    });
  }

  /// يغلق الجلسة المفتوحة ويعيد حساب اليوم من كل جلساته.
  @override
  Future<void> checkOut(DateTime time, {int? companyId}) async {
    final isar = await _db;

    // الجلسة المفتوحة تُبحث عبر الجهات كلها ثم تُحسب بشروط **جهتها هي**.
    // ربطها بالجهة المعروضة كان يفشل حين يبدّل المستخدم بعد الحضور، ولو
    // نجح لحسب الساعات بأجر جهة أخرى.
    final query = isar.attendanceModels.filter().isOpenEqualTo(true);
    final record = companyId == null
        ? await query.sortByDateDesc().findFirst()
        : await query.companyIdEqualTo(companyId).sortByDateDesc().findFirst();

    if (record == null) {
      // تشخيص: الرسالة وحدها لا تقول هل العَلَم المخزَّن مطفأ أم أن السجل
      // يخص جهة أخرى — وهذان سببان مختلفان تماماً.
      final all = await isar.attendanceModels.where().findAll();
      developer.log(
        'فشل الانصراف: ${all.length} سجل، '
        'المفتوحة=${all.where((r) => r.isOpen).length}، '
        'بجلسة غير مغلقة=${all.where((r) => r.sessions.any((s) => s.checkOut == null)).length}، '
        'الجهات=${all.map((r) => r.companyId).toSet()}',
        name: 'attendance.checkout',
        level: 900,
      );
      throw Exception('لا توجد جلسة دوام مفتوحة');
    }

    final company = await isar.companyModels.get(record.companyId);
    if (company == null) throw Exception('جهة هذه الجلسة غير موجودة');

    final sessions = [...record.sessions];
    final openIndex = sessions.lastIndexWhere((s) => s.checkOut == null);
    if (openIndex < 0) throw Exception('لا توجد جلسة دوام مفتوحة');

    final open = sessions[openIndex];
    if (open.checkIn != null && time.isBefore(open.checkIn!)) {
      throw Exception('وقت الانصراف قبل وقت الحضور');
    }
    sessions[openIndex] = open..checkOut = time;
    record.sessions = sessions;

    final companyEntity = _mapCompanyToEntity(company);
    final effective = await _effectiveConfig(isar, companyEntity, record.date);
    _recalculate(record, companyEntity, effective.config, effective.dayType);

    await isar.writeTxn(() async {
      await isar.attendanceModels.put(record);
    });
  }

  @override
  Future<void> addManualRecord({
    required DateTime date,
    required DateTime checkIn,
    required DateTime checkOut,
    String? notes,
  }) async {
    final isar = await _db;
    final company = await _activeCompany(isar);

    final companyEntity = _mapCompanyToEntity(company);
    final day = DateHelpers.startOfDay(date);
    final effective = await _effectiveConfig(isar, companyEntity, date);
    final dayConfig = effective.config;

    // جلسة يدوية تُضاف لسجل اليوم **في هذه الجهة** إن وُجد، بدل إنشاء سجل
    // ثانٍ لنفس التاريخ أو إلحاقها بسجل جهة أخرى.
    final record = await isar.attendanceModels
            .filter()
            .companyIdEqualTo(company.id)
            .dateBetween(day, DateHelpers.endOfDay(date))
            .findFirst() ??
        _newRecord(day, dayConfig, company.id);

    record.sessions = [
      ...record.sessions,
      WorkSession()
        ..checkIn = checkIn
        ..checkOut = checkOut
        ..isBiometricVerified = false,
    ]..sort((a, b) => (a.checkIn ?? day).compareTo(b.checkIn ?? day));

    // داخل الجهة الواحدة، الدقائق المشتركة بين جلستين تُحتسب مرّتين: ينتفخ
    // التواجد والإضافي ويُدفع أجر عن وقت لم يُعمل.
    _assertNoOverlap(record);

    record.notes = notes ?? record.notes;
    record.isAbsent = false;
    _recalculate(record, companyEntity, dayConfig, effective.dayType);

    await isar.writeTxn(() async {
      await isar.attendanceModels.put(record);
    });
  }

  @override
  Future<void> updateRecord(AttendanceEntity entity) async {
    final isar = await _db;
    final model = await isar.attendanceModels.get(entity.id);
    if (model == null) throw Exception('Record not found');

    // شروط **جهة السجل نفسه**، لا الجهة المعروضة. تعديل يوم قديم بعد تبديل
    // الجهة كان يعيد حسابه بجدول وأجر جهة أخرى، فتتغيّر قيمته المالية بلا
    // أن يمسّ المستخدم رقماً واحداً.
    final company = await isar.companyModels.get(model.companyId);
    if (company == null) throw Exception('جهة هذا السجل غير موجودة');

    final companyEntity = _mapCompanyToEntity(company);

    model
      ..notes = entity.notes
      ..isAbsent = entity.isAbsent
      ..sessions = entity.isAbsent
          ? []
          : [
              for (final session in entity.sessions)
                if (session.checkIn != null)
                  WorkSession()
                    ..checkIn = session.checkIn
                    ..checkOut = session.checkOut
                    ..isBiometricVerified = session.isBiometricVerified
                    ..note = session.note,
            ];

    _assertNoOverlap(model);
    final effective = await _effectiveConfig(isar, companyEntity, model.date);
    _recalculate(model, companyEntity, effective.config, effective.dayType);

    await isar.writeTxn(() async {
      await isar.attendanceModels.put(model);
    });
  }

  @override
  Future<void> deleteRecord(int id) async {
    final isar = await _db;
    final companyId = await _activeCompanyId(isar);
    final record = await isar.attendanceModels.get(id);
    CompanyScope.assertOwned(
      recordCompanyId: record?.companyId,
      activeCompanyId: companyId,
      subject: 'هذا السجل',
    );

    await isar.writeTxn(() async {
      await isar.attendanceModels.delete(id);
    });
  }

  // ── الحساب ──────────────────────────────────────────────────────

  /// يكتب على السجل ما حسبته [AttendanceCalculationService].
  ///
  /// هذه هي النقطة الوحيدة التي تُكتب فيها الحقول المشتقّة، فأي مسار
  /// (بصمة، يدوي، تعديل) يمرّ منها ويبقى السجل متسقاً. الحساب نفسه انتقل
  /// إلى الدومين، فبقي هنا الربط بين الأرقام والنموذج لا اشتقاقها.
  void _recalculate(
    AttendanceModel record,
    CompanyEntity company,
    WorkDayConfigEntity dayConfig,
    OvertimeDayType dayType,
  ) {
    final result = const AttendanceCalculationService()(
      sessions: [
        for (final session in record.sessions)
          SessionInput(
            checkIn: session.checkIn,
            checkOut: session.checkOut,
            isBiometricVerified: session.isBiometricVerified,
          ),
      ],
      company: company,
      dayConfig: dayConfig,
      isAbsent: record.isAbsent,
      dayType: dayType,
    );

    record
      ..isOpen = result.isOpen
      ..sessionCount = result.sessionCount
      ..checkIn = result.firstCheckIn
      ..checkOut = result.lastCheckOut
      ..isBiometricVerified = result.isBiometricVerified
      ..requiredHours = result.requiredHours
      ..requiredMinutes = result.requiredMinutes
      ..totalPresenceMinutes = result.presenceMinutes
      ..workedHours = result.officialMinutes ~/ 60
      ..workedMinutes = result.officialMinutes % 60
      ..overtimeHours = result.overtimeMinutes ~/ 60
      ..overtimeMinutes = result.overtimeMinutes % 60
      ..overtimeValue = result.overtimeValue
      ..deficitHours = result.deficitMinutes ~/ 60
      ..deficitMinutes = result.deficitMinutes % 60
      ..deficitValue = result.deficitValue;
  }

  /// إعداد اليوم بعد تطبيق تقويم الجهة عليه.
  ///
  /// العطلة تُفرِّغ المطلوب، فيصير كل تواجد فيها إضافياً بدل أن يُقاس على
  /// ساعات لم تُطلَب. والقراءة تمرّ من هنا وحدها كي لا يحسب مسارٌ اليومَ
  /// بجدوله الخام بينما يحسبه آخر بتقويمه.
  Future<({WorkDayConfigEntity config, OvertimeDayType dayType})>
      _effectiveConfig(
    Isar isar,
    CompanyEntity company,
    DateTime date,
  ) async {
    final day = DateHelpers.startOfDay(date);
    final scheduled = company.configFor(date);
    final entries = await isar.calendarDayModels
        .filter()
        .dateBetween(day, DateHelpers.endOfDay(date))
        .group((q) => q.companyIdEqualTo(company.id).or().companyIdIsNull())
        .findAll();

    final entry = entries.isEmpty
        ? null
        : EffectiveDayResolver.governing(
            entries.map(_calendarToEntity).toList(), company.id);

    return (
      config: EffectiveDayResolver.apply(base: scheduled, entry: entry),
      dayType: EffectiveDayResolver.dayTypeOf(
          scheduled: scheduled, entry: entry),
    );
  }

  static CalendarDayEntity _calendarToEntity(CalendarDayModel m) =>
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

  static OvertimePolicyEntity? _overtimePolicy(OvertimePolicy? p) {
    final normal = p?.normal;
    if (normal == null) return null;
    OvertimeRateEntity? rate(OvertimeRate? r) => r == null
        ? null
        : OvertimeRateEntity(
            kind: switch (r.kind) {
              OvertimeRateKindStored.multiplier => OvertimeRateKind.multiplier,
              OvertimeRateKindStored.fixedPerHour =>
                OvertimeRateKind.fixedPerHour,
              OvertimeRateKindStored.fixedPerDay =>
                OvertimeRateKind.fixedPerDay,
            },
            value: r.value);
    return OvertimePolicyEntity(
      normal: rate(normal)!,
      weekend: rate(p?.weekend),
      publicHoliday: rate(p?.publicHoliday),
      workplaceHoliday: rate(p?.workplaceHoliday),
    );
  }

  static void _assertNoOverlap(AttendanceModel record) {
    SessionOverlapRule.assertNoOverlap([
      for (final session in record.sessions)
        SessionInput(checkIn: session.checkIn, checkOut: session.checkOut),
    ]);
  }

  AttendanceModel _newRecord(
    DateTime day,
    WorkDayConfigEntity dayConfig,
    int companyId,
  ) {
    return AttendanceModel()
      ..companyId = companyId
      ..date = day
      ..sessions = []
      ..requiredHours = dayConfig.requiredHours
      ..requiredMinutes = dayConfig.requiredMinutes
      ..workedHours = 0
      ..workedMinutes = 0
      ..overtimeHours = 0
      ..overtimeMinutes = 0
      ..overtimeValue = 0
      ..deficitHours = 0
      ..deficitMinutes = 0
      ..deficitValue = 0
      ..isBiometricVerified = false
      ..isAbsent = false
      ..dayType = _resolveDayType(dayConfig);
  }

  CompanyEntity _mapCompanyToEntity(CompanyModel company) {
    return CompanyEntity(
      id: company.id,
      name: company.name,
      jobTitle: company.jobTitle,
      baseMonthlySalary: company.baseMonthlySalary,
      hourlyRate: company.hourlyRate,
      overtimeRate: company.overtimeRate,
      explicitOvertimePolicy: _overtimePolicy(company.overtimePolicy),
      policy: WorkPolicyEntity(
        graceMinutes: company.policy?.graceMinutes ?? 0,
        minOvertimeMinutes: company.policy?.minOvertimeMinutes ?? 0,
        paysOvertime: company.policy?.paysOvertime ?? true,
      ),
      workSchedule: company.workSchedule
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
      adjustments: company.adjustments
          .map((a) => SalaryAdjustmentEntity(
                title: a.title,
                amount: a.amount,
                isAddition: a.isAddition,
              ))
          .toList(),
      currency: company.currency,
      employmentStartDate: company.employmentStartDate,
      colorIndex: company.colorIndex,
      isArchived: company.isArchived,
      createdAt: company.createdAt,
      updatedAt: company.updatedAt,
    );
  }

  static DayType _resolveDayType(WorkDayConfigEntity config) {
    if (config.isHoliday) return DayType.holiday;
    if (config.dayOfWeek == DateTime.friday) return DayType.friday;
    if (config.dayOfWeek == DateTime.thursday) return DayType.thursday;
    return DayType.regular;
  }

  AttendanceEntity _mapToEntity(AttendanceModel m) {
    return AttendanceEntity(
      id: m.id,
      companyId: m.companyId,
      date: m.date,
      sessions: [
        for (final session in m.sessions)
          WorkSessionEntity(
            checkIn: session.checkIn,
            checkOut: session.checkOut,
            isBiometricVerified: session.isBiometricVerified,
            note: session.note,
          ),
      ],
      checkIn: m.checkIn,
      checkOut: m.checkOut,
      isOpen: m.isOpen,
      totalPresenceMinutes: m.totalPresenceMinutes,
      sessionCount: m.sessionCount,
      workedHours: m.workedHours,
      workedMinutes: m.workedMinutes,
      requiredHours: m.requiredHours,
      requiredMinutes: m.requiredMinutes,
      overtimeHours: m.overtimeHours,
      overtimeMinutes: m.overtimeMinutes,
      overtimeValue: m.overtimeValue,
      deficitHours: m.deficitHours,
      deficitMinutes: m.deficitMinutes,
      deficitValue: m.deficitValue,
      notes: m.notes,
      isBiometricVerified: m.isBiometricVerified,
      dayType: m.dayType.name,
      isAbsent: m.isAbsent,
    );
  }
}
