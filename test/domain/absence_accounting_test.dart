import 'package:attendance_budget_app/domain/entities/attendance_entity.dart';
import 'package:attendance_budget_app/domain/entities/company_entity.dart';
import 'package:attendance_budget_app/domain/entities/profile_entity.dart';
import 'package:attendance_budget_app/domain/repositories/attendance_repository.dart';
import 'package:attendance_budget_app/domain/usecases/attendance/get_monthly_stats_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAttendanceRepository implements AttendanceRepository {
  _FakeAttendanceRepository(this._records);

  final List<AttendanceEntity> _records;

  @override
  Future<List<AttendanceEntity>> getMonthlyRecords(int year, int month) async =>
      _records;

  @override
  Future<List<AttendanceEntity>> getRecordsBetween(
          DateTime from, DateTime to) async =>
      _records;

  @override
  Future<List<AttendanceEntity>> getRecordsForCompany(
          int companyId, DateTime from, DateTime to) async =>
      _records;

  @override
  Future<AttendanceEntity?> getTodayRecord() async => null;

  @override
  Future<AttendanceEntity?> getAnyOpenSession() async => null;

  @override
  Future<void> checkIn(DateTime time,
      {bool isBiometricVerified = false, int? companyId}) async {}

  @override
  Future<void> checkOut(DateTime time, {int? companyId}) async {}

  @override
  Future<void> addManualRecord({
    required DateTime date,
    required DateTime checkIn,
    required DateTime checkOut,
    String? notes,
  }) async {}

  @override
  Future<void> updateRecord(AttendanceEntity entity) async {}

  @override
  Future<void> deleteRecord(int id) async {}
}

/// أجر الساعة 20 وثماني ساعات يومياً: يوم الغياب يساوي 160.
CompanyEntity _company() => CompanyEntity(
      id: 1,
      name: 'جهة',
      jobTitle: 'مطوّر',
      baseMonthlySalary: 3000,
      hourlyRate: 20,
      overtimeRate: 1.5,
      workSchedule: [
        for (var day = 1; day <= 7; day++)
          WorkDayConfigEntity(
            dayOfWeek: day,
            isWorkingDay: true,
            requiredHours: 8,
            requiredMinutes: 0,
            isHoliday: false,
          ),
      ],
      adjustments: const [],
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

/// غياب معلن: بلا جلسات، وعجزه محسوب في السجل كما يكتبه `_recalculate`.
AttendanceEntity _declaredAbsence(DateTime date) => AttendanceEntity(
      id: date.day,
      date: date,
      sessions: const [],
      workedHours: 0,
      workedMinutes: 0,
      requiredHours: 8,
      requiredMinutes: 0,
      overtimeHours: 0,
      overtimeMinutes: 0,
      overtimeValue: 0,
      deficitHours: 8,
      deficitMinutes: 0,
      deficitValue: 160,
      isBiometricVerified: false,
      dayType: 'regular',
      isAbsent: true,
    );

void main() {
  group('الغياب المعلن يُحتسب كالغياب الصامت', () {
    test('يوم غياب معلن يضيف عجزه وساعاته', () async {
      final stats = await GetMonthlyStatsUseCase(
        _FakeAttendanceRepository([_declaredAbsence(DateTime(2026, 2, 3))]),
      )(2026, 2, _company());

      expect(stats.totalAbsenceHours, 224,
          reason: 'اليوم المعلن غياباً سقط من ساعات الغياب');
      expect(stats.totalDeficitValue, closeTo(4480, 0.001));
      expect(stats.absentDays, 28);
    });

    test('إعلان الغياب لا يجعله أرخص من تركه فارغاً', () async {
      final declared = await GetMonthlyStatsUseCase(
        _FakeAttendanceRepository([_declaredAbsence(DateTime(2026, 2, 3))]),
      )(2026, 2, _company());

      // نفس الشهر بلا أي سجل إطلاقاً.
      final silent = await GetMonthlyStatsUseCase(
        _FakeAttendanceRepository(const []),
      )(2026, 2, _company());

      expect(declared.totalDeficitValue, closeTo(silent.totalDeficitValue, 0.001),
          reason: 'إعلان الغياب ألغى عقوبته');
      expect(declared.totalAbsenceHours, silent.totalAbsenceHours);
    });
  });
}
