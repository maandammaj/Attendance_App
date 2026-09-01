import 'package:isar_community/isar.dart';
import '../../../core/utils/date_helpers.dart';
import '../../../core/utils/salary_calculator.dart';
import '../../../domain/entities/attendance_entity.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../../domain/repositories/attendance_repository.dart';
import '../../models/attendance_model.dart';
import '../../models/profile_model.dart';
import '../database/isar_database.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  Future<Isar> get _db async => await IsarDatabase.instance;

  @override
  Future<AttendanceEntity?> getTodayRecord() async {
    final isar = await _db;
    final today = DateTime.now();
    
    final record = await isar.attendanceModels
        .filter()
        .checkOutIsNull()
        .or()
        .dateBetween(DateHelpers.startOfDay(today), DateHelpers.endOfDay(today))
        .sortByDateDesc()
        .findFirst();
        
    return record != null ? _mapToEntity(record) : null;
  }

  @override
  Future<List<AttendanceEntity>> getMonthlyRecords(int year, int month) async {
    final isar = await _db;
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 0, 23, 59, 59);
    final records = await isar.attendanceModels
        .filter()
        .dateBetween(start, end)
        .sortByDateDesc()
        .findAll();
    return records.map(_mapToEntity).toList();
  }

  @override
  Future<void> checkIn(DateTime time) async {
    final isar = await _db;
    final profile = await isar.profileModels.get(0);
    if (profile == null) throw Exception('Profile not set');

    final lastOpen = await isar.attendanceModels
        .filter()
        .checkOutIsNull()
        .sortByDateDesc()
        .findFirst();
        
    if (lastOpen != null) return;

    final today = DateHelpers.startOfDay(time);
    final dayConfig = profile.workSchedule.firstWhere(
      (d) => d.dayOfWeek == time.weekday % 7,
      orElse: () => WorkDayConfig()
        ..dayOfWeek = time.weekday % 7
        ..isWorkingDay = true
        ..requiredHours = 8
        ..requiredMinutes = 0
        ..isHoliday = false,
    );

    final dayType = _resolveDayType(dayConfig);

    final record = AttendanceModel()
      ..date = today
      ..checkIn = time
      ..requiredHours = dayConfig.requiredHours
      ..requiredMinutes = dayConfig.requiredMinutes
      ..overtimeHours = 0
      ..overtimeMinutes = 0
      ..overtimeValue = 0
      ..deficitHours = 0
      ..deficitMinutes = 0
      ..deficitValue = 0
      ..workedHours = 0
      ..workedMinutes = 0
      ..isBiometricVerified = true
      ..isAbsent = false
      ..dayType = dayType;

    await isar.writeTxn(() async {
      await isar.attendanceModels.put(record);
    });
  }

  @override
  Future<void> checkOut(DateTime time) async {
    final isar = await _db;
    final profile = await isar.profileModels.get(0);
    if (profile == null) throw Exception('Profile not set');

    final record = await isar.attendanceModels
        .filter()
        .checkOutIsNull()
        .sortByDateDesc()
        .findFirst();

    if (record == null || record.checkIn == null) {
      throw Exception('لا يوجد سجل دخول نشط');
    }

    record.checkOut = time;
    final profileEntity = _mapProfileToEntity(profile);
    final calculator = SalaryCalculator(profileEntity);
    
    final dayConfig = profileEntity.workSchedule.firstWhere(
      (d) => d.dayOfWeek == record.date.weekday % 7,
      orElse: () => WorkDayConfigEntity(dayOfWeek: record.date.weekday % 7, isWorkingDay: true, requiredHours: 8, requiredMinutes: 0, isHoliday: false),
    );

    final details = calculator.calculateShiftDetails(
      actualCheckIn: record.checkIn!,
      actualCheckOut: time,
      scheduledStart: dayConfig.startTime,
      scheduledEnd: dayConfig.endTime,
      isCrossDay: dayConfig.isCrossDay,
    );

    record.workedHours = details.officialMinutes ~/ 60;
    record.workedMinutes = details.officialMinutes % 60;
    
    record.overtimeHours = details.overtimeMinutes ~/ 60;
    record.overtimeMinutes = details.overtimeMinutes % 60;
    record.overtimeValue = calculator.calculateOvertimeValue(record.overtimeHours, record.overtimeMinutes);

    record.deficitHours = details.deficitMinutes ~/ 60;
    record.deficitMinutes = details.deficitMinutes % 60;
    record.deficitValue = calculator.calculateDeficitValue(record.deficitHours, record.deficitMinutes);

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
    final profile = await isar.profileModels.get(0);
    if (profile == null) throw Exception('Profile not set');

    final profileEntity = _mapProfileToEntity(profile);
    final calculator = SalaryCalculator(profileEntity);

    final dayConfig = profileEntity.workSchedule.firstWhere(
      (d) => d.dayOfWeek == date.weekday % 7,
      orElse: () => WorkDayConfigEntity(
          dayOfWeek: date.weekday % 7,
          isWorkingDay: true,
          requiredHours: 8,
          requiredMinutes: 0,
          isHoliday: false),
    );

    final details = calculator.calculateShiftDetails(
      actualCheckIn: checkIn,
      actualCheckOut: checkOut,
      scheduledStart: dayConfig.startTime,
      scheduledEnd: dayConfig.endTime,
      isCrossDay: dayConfig.isCrossDay,
    );

    final record = AttendanceModel()
      ..date = DateHelpers.startOfDay(date)
      ..checkIn = checkIn
      ..checkOut = checkOut
      ..notes = notes
      ..workedHours = details.officialMinutes ~/ 60
      ..workedMinutes = details.officialMinutes % 60
      ..requiredHours = dayConfig.requiredHours
      ..requiredMinutes = dayConfig.requiredMinutes
      ..overtimeHours = details.overtimeMinutes ~/ 60
      ..overtimeMinutes = details.overtimeMinutes % 60
      ..overtimeValue = calculator.calculateOvertimeValue(
          details.overtimeMinutes ~/ 60, details.overtimeMinutes % 60)
      ..deficitHours = details.deficitMinutes ~/ 60
      ..deficitMinutes = details.deficitMinutes % 60
      ..deficitValue = calculator.calculateDeficitValue(
          details.deficitMinutes ~/ 60, details.deficitMinutes % 60)
      ..isBiometricVerified = false
      ..isAbsent = false
      ..dayType = _resolveDayType(WorkDayConfig()
        ..dayOfWeek = dayConfig.dayOfWeek
        ..isHoliday = dayConfig.isHoliday);

    await isar.writeTxn(() async {
      await isar.attendanceModels.put(record);
    });
  }

  @override
  Future<void> updateRecord(AttendanceEntity entity) async {
    final isar = await _db;
    final model = await isar.attendanceModels.get(entity.id);
    if (model == null) throw Exception('Record not found');

    final profile = await isar.profileModels.get(0);
    if (profile == null) throw Exception('Profile not set');

    final profileEntity = _mapProfileToEntity(profile);
    final calculator = SalaryCalculator(profileEntity);

    model
      ..checkIn = entity.checkIn
      ..checkOut = entity.checkOut
      ..notes = entity.notes
      ..isAbsent = entity.isAbsent;

    if (!entity.isAbsent && entity.checkIn != null && entity.checkOut != null) {
      final dayConfig = profileEntity.workSchedule.firstWhere(
        (d) => d.dayOfWeek == model.date.weekday % 7,
        orElse: () => WorkDayConfigEntity(
            dayOfWeek: model.date.weekday % 7,
            isWorkingDay: true,
            requiredHours: 8,
            requiredMinutes: 0,
            isHoliday: false),
      );

      final details = calculator.calculateShiftDetails(
        actualCheckIn: entity.checkIn!,
        actualCheckOut: entity.checkOut!,
        scheduledStart: dayConfig.startTime,
        scheduledEnd: dayConfig.endTime,
        isCrossDay: dayConfig.isCrossDay,
      );

      model
        ..workedHours = details.officialMinutes ~/ 60
        ..workedMinutes = details.officialMinutes % 60
        ..overtimeHours = details.overtimeMinutes ~/ 60
        ..overtimeMinutes = details.overtimeMinutes % 60
        ..overtimeValue = calculator.calculateOvertimeValue(
            details.overtimeMinutes ~/ 60, details.overtimeMinutes % 60)
        ..deficitHours = details.deficitMinutes ~/ 60
        ..deficitMinutes = details.deficitMinutes % 60
        ..deficitValue = calculator.calculateDeficitValue(
            details.deficitMinutes ~/ 60, details.deficitMinutes % 60);
    } else if (entity.isAbsent) {
      final dayConfig = profileEntity.workSchedule.firstWhere(
        (d) => d.dayOfWeek == model.date.weekday % 7,
        orElse: () => WorkDayConfigEntity(
            dayOfWeek: model.date.weekday % 7,
            isWorkingDay: true,
            requiredHours: 8,
            requiredMinutes: 0,
            isHoliday: false),
      );
      final missingMinutes =
          (dayConfig.requiredHours * 60) + dayConfig.requiredMinutes;

      model
        ..workedHours = 0
        ..workedMinutes = 0
        ..overtimeHours = 0
        ..overtimeMinutes = 0
        ..overtimeValue = 0
        ..deficitHours = missingMinutes ~/ 60
        ..deficitMinutes = missingMinutes % 60
        ..deficitValue = calculator.calculateDeficitValue(
            missingMinutes ~/ 60, missingMinutes % 60);
    }

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

  ProfileEntity _mapProfileToEntity(ProfileModel profile) {
    return ProfileEntity(
      id: profile.id,
      fullName: profile.fullName,
      jobTitle: profile.jobTitle,
      baseMonthlySalary: profile.baseMonthlySalary,
      hourlyRate: profile.hourlyRate,
      overtimeRate: profile.overtimeRate,
      workSchedule: profile.workSchedule
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
      adjustments: profile.adjustments
          .map((a) => SalaryAdjustmentEntity(
                title: a.title,
                amount: a.amount,
                isAddition: a.isAddition,
              ))
          .toList(),
      currency: profile.currency,
      companyName: profile.companyName,
      employmentStartDate: profile.employmentStartDate,
      updatedAt: profile.updatedAt,
    );
  }

  DayType _resolveDayType(WorkDayConfig config) {
    if (config.isHoliday) return DayType.holiday;
    if (config.dayOfWeek == 5) return DayType.friday;
    if (config.dayOfWeek == 4) return DayType.thursday;
    return DayType.regular;
  }

  AttendanceEntity _mapToEntity(AttendanceModel m) {
    return AttendanceEntity(
      id: m.id,
      date: m.date,
      checkIn: m.checkIn,
      checkOut: m.checkOut,
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
