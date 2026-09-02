import 'package:attendance_budget_app/domain/entities/attendance_entity.dart';
import 'package:attendance_budget_app/domain/entities/company_entity.dart';
import 'package:attendance_budget_app/domain/entities/profile_entity.dart';
import 'package:attendance_budget_app/domain/repositories/attendance_repository.dart';
import 'package:attendance_budget_app/domain/usecases/attendance/get_monthly_stats_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

/// مستودع بديل يعيد سجلات محدّدة — لا قاعدة بيانات في اختبارات الدومين.
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
  Future<AttendanceEntity?> getTodayRecord() async => null;

  @override
  Future<List<AttendanceEntity>> getRecordsForCompany(
          int companyId, DateTime from, DateTime to) async =>
      _records;

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

CompanyEntity _company() => CompanyEntity(
      id: 1,
      name: 'جهة',
      jobTitle: 'مطوّر',
      baseMonthlySalary: 3000,
      hourlyRate: 20,
      overtimeRate: 1.5,
      // كل الأيام عمل بثماني ساعات، ليصير الحساب متوقّعاً.
      workSchedule: [
        for (int day = 1; day <= 7; day++)
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

AttendanceEntity _record({
  required DateTime date,
  required int workedMinutes,
  int overtimeMinutes = 0,
  int presenceMinutes = 0,
}) {
  return AttendanceEntity(
    id: date.day,
    date: date,
    sessions: [
      WorkSessionEntity(checkIn: date, checkOut: date.add(const Duration(hours: 8))),
    ],
    totalPresenceMinutes:
        presenceMinutes == 0 ? workedMinutes + overtimeMinutes : presenceMinutes,
    sessionCount: 1,
    workedHours: workedMinutes ~/ 60,
    workedMinutes: workedMinutes % 60,
    requiredHours: 8,
    requiredMinutes: 0,
    overtimeHours: overtimeMinutes ~/ 60,
    overtimeMinutes: overtimeMinutes % 60,
    overtimeValue: 0,
    deficitHours: 0,
    deficitMinutes: 0,
    deficitValue: 0,
    isBiometricVerified: true,
    dayType: 'regular',
  );
}

void main() {
  group('إجماليات ساعات الشهر', () {
    test('تجمع المطلوب والمنجز والتواجد عبر كل السجلات', () async {
      // شهر مضى بالكامل: فبراير 2026 (28 يوماً).
      final records = [
        for (int day = 1; day <= 3; day++)
          _record(
            date: DateTime(2026, 2, day),
            workedMinutes: 480,
            overtimeMinutes: 60,
          ),
      ];

      final stats = await GetMonthlyStatsUseCase(
        _FakeAttendanceRepository(records),
      )(2026, 2, _company());

      // 28 يوم عمل × 8 ساعات.
      expect(stats.totalRequiredHours, 224);
      expect(stats.totalWorkedHours, 24);
      expect(stats.totalPresenceHours, 27);
      expect(stats.totalOvertimeHours, 3);
      expect(stats.actualWorkingDays, 3);
    });

    test('نسبة الإنجاز = المنجز على المطلوب', () async {
      final records = [
        for (int day = 1; day <= 14; day++)
          _record(date: DateTime(2026, 2, day), workedMinutes: 480),
      ];

      final stats = await GetMonthlyStatsUseCase(
        _FakeAttendanceRepository(records),
      )(2026, 2, _company());

      // 112 من 224 = نصف الشهر بالضبط.
      expect(stats.completionRate, closeTo(0.5, 0.001));
    });

    test('شهر بلا سجلات: المطلوب قائم والمنجز صفر', () async {
      final stats = await GetMonthlyStatsUseCase(
        _FakeAttendanceRepository(const []),
      )(2026, 2, _company());

      expect(stats.totalRequiredHours, 224);
      expect(stats.totalWorkedHours, 0);
      expect(stats.completionRate, 0);
      expect(stats.absentDays, 28);
      // الغياب كله يتحوّل إلى ساعات عجز.
      expect(stats.totalAbsenceHours, 224);
    });
  });
}
