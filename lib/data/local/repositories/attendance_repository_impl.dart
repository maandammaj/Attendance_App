import 'package:isar_community/isar.dart';

import '../../../core/utils/date_helpers.dart';
import '../../../core/utils/salary_calculator.dart';
import '../../../domain/entities/attendance_entity.dart';
import '../../../domain/entities/company_entity.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../../domain/repositories/attendance_repository.dart';
import '../../models/attendance_model.dart';
import '../../models/company_model.dart';
import '../../models/profile_model.dart';
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

    // الجلسة المفتوحة لها الأولوية حتى لو بدأت أمس (وردية عابرة لمنتصف الليل).
    final open = await isar.attendanceModels
        .filter()
        .isOpenEqualTo(true)
        .sortByDateDesc()
        .findFirst();
    if (open != null) return _mapToEntity(open);

    final record = await isar.attendanceModels
        .filter()
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
      throw Exception('لديك جلسة دوام مفتوحة بالفعل، سجّل الانصراف أولاً');
    }

    final companyEntity = _mapCompanyToEntity(company);
    final day = DateHelpers.startOfDay(time);
    final dayConfig = _configFor(companyEntity, time);

    final record = await isar.attendanceModels
            .filter()
            .dateBetween(day, DateHelpers.endOfDay(time))
            .findFirst() ??
        _newRecord(day, dayConfig);

    record.sessions = [
      ...record.sessions,
      WorkSession()
        ..checkIn = time
        ..isBiometricVerified = isBiometricVerified,
    ];
    record.isAbsent = false;
    _recalculate(record, companyEntity, dayConfig);

    await isar.writeTxn(() async {
      await isar.attendanceModels.put(record);
    });
  }

  /// يغلق الجلسة المفتوحة ويعيد حساب اليوم من كل جلساته.
  @override
  Future<void> checkOut(DateTime time) async {
    final isar = await _db;
    final company = await _activeCompany(isar);

    final companyId = await _activeCompanyId(isar);
    final record = await isar.attendanceModels
        .filter()
        .companyIdEqualTo(companyId)
        .isOpenEqualTo(true)
        .sortByDateDesc()
        .findFirst();

    if (record == null) throw Exception('لا توجد جلسة دوام مفتوحة');

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
    _recalculate(record, companyEntity, _configFor(companyEntity, record.date));

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
    final dayConfig = _configFor(companyEntity, date);

    // جلسة يدوية تُضاف لسجل اليوم إن وُجد بدل إنشاء سجل ثانٍ لنفس التاريخ.
    final record = await isar.attendanceModels
            .filter()
            .dateBetween(day, DateHelpers.endOfDay(date))
            .findFirst() ??
        _newRecord(day, dayConfig);

    record.sessions = [
      ...record.sessions,
      WorkSession()
        ..checkIn = checkIn
        ..checkOut = checkOut
        ..isBiometricVerified = false,
    ]..sort((a, b) => (a.checkIn ?? day).compareTo(b.checkIn ?? day));

    record.notes = notes ?? record.notes;
    record.isAbsent = false;
    _recalculate(record, companyEntity, dayConfig);

    await isar.writeTxn(() async {
      await isar.attendanceModels.put(record);
    });
  }

  @override
  Future<void> updateRecord(AttendanceEntity entity) async {
    final isar = await _db;
    final model = await isar.attendanceModels.get(entity.id);
    if (model == null) throw Exception('Record not found');

    final company = await _activeCompany(isar);

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

    _recalculate(model, companyEntity, _configFor(companyEntity, model.date));

    await isar.writeTxn(() async {
      await isar.attendanceModels.put(model);
    });
  }

  @override
  Future<void> deleteRecord(int id) async {
    final isar = await _db;
    await isar.writeTxn(() async {
      await isar.attendanceModels.delete(id);
    });
  }

  // ── الحساب ──────────────────────────────────────────────────────

  /// يعيد اشتقاق كل القيم المخزَّنة من [AttendanceModel.sessions].
  ///
  /// هذه هي النقطة الوحيدة التي تُكتب فيها الحقول المشتقّة، فأي مسار
  /// (بصمة، يدوي، تعديل) يمرّ منها ويبقى السجل متسقاً.
  void _recalculate(
    AttendanceModel record,
    CompanyEntity company,
    WorkDayConfigEntity dayConfig,
  ) {
    final closed = record.sessions
        .where((s) => s.checkIn != null && s.checkOut != null)
        .toList();

    record.isOpen = record.sessions.any((s) => s.checkIn != null && s.checkOut == null);
    record.sessionCount = closed.length;
    record.checkIn = record.sessions.isEmpty ? null : record.sessions.first.checkIn;
    record.checkOut = record.isOpen || record.sessions.isEmpty
        ? null
        : record.sessions.last.checkOut;
    record.isBiometricVerified = record.sessions.isNotEmpty &&
        record.sessions.every((s) => s.isBiometricVerified);
    record.requiredHours = dayConfig.requiredHours;
    record.requiredMinutes = dayConfig.requiredMinutes;

    record.totalPresenceMinutes = closed.fold(
      0,
      (sum, s) {
        final minutes = s.checkOut!.difference(s.checkIn!).inMinutes;
        return sum + (minutes < 0 ? 0 : minutes);
      },
    );

    // الجلسة المفتوحة لا تدخل الحساب المالي حتى تُغلق: قيمتها غير نهائية.
    final calculator = SalaryCalculator(company);
    final details = calculator.calculateDayDetails(
      sessions: [
        for (final session in closed)
          SalaryCalculator.presence(session.checkIn!, session.checkOut!),
      ],
      scheduledStart: dayConfig.startTime,
      scheduledEnd: dayConfig.endTime,
      isCrossDay: dayConfig.isCrossDay,
      requiredHours: dayConfig.requiredHours,
      requiredMinutes: dayConfig.requiredMinutes,
    );

    record.workedHours = details.officialMinutes ~/ 60;
    record.workedMinutes = details.officialMinutes % 60;
    record.overtimeHours = details.overtimeMinutes ~/ 60;
    record.overtimeMinutes = details.overtimeMinutes % 60;
    record.overtimeValue = calculator.calculateOvertimeValue(
        details.overtimeMinutes ~/ 60, details.overtimeMinutes % 60);
    record.deficitHours = details.deficitMinutes ~/ 60;
    record.deficitMinutes = details.deficitMinutes % 60;
    record.deficitValue = calculator.calculateDeficitValue(
        details.deficitMinutes ~/ 60, details.deficitMinutes % 60);

    // يوم بلا جلسات مغلقة ولا جلسة مفتوحة لا يُحتسب عليه عجز إلا إن أُعلن غياباً.
    if (closed.isEmpty && !record.isOpen && !record.isAbsent) {
      record.deficitHours = 0;
      record.deficitMinutes = 0;
      record.deficitValue = 0;
    }
  }

  AttendanceModel _newRecord(DateTime day, WorkDayConfigEntity dayConfig) {
    return AttendanceModel()
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

  static WorkDayConfigEntity _configFor(CompanyEntity company, DateTime date) {
    final scheduleDay = DateHelpers.scheduleDayOf(date);
    return company.workSchedule.firstWhere(
      (day) => day.dayOfWeek == scheduleDay,
      orElse: () => WorkDayConfigEntity(
        dayOfWeek: scheduleDay,
        isWorkingDay: true,
        requiredHours: 8,
        requiredMinutes: 0,
        isHoliday: false,
      ),
    );
  }

  CompanyEntity _mapCompanyToEntity(CompanyModel company) {
    return CompanyEntity(
      id: company.id,
      name: company.name,
      jobTitle: company.jobTitle,
      baseMonthlySalary: company.baseMonthlySalary,
      hourlyRate: company.hourlyRate,
      overtimeRate: company.overtimeRate,
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
