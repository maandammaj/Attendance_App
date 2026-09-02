import 'package:attendance_budget_app/domain/entities/analytics_report_entity.dart';
import 'package:attendance_budget_app/domain/entities/attendance_entity.dart';
import 'package:attendance_budget_app/domain/entities/company_entity.dart';
import 'package:attendance_budget_app/domain/entities/profile_entity.dart';
import 'package:attendance_budget_app/domain/repositories/attendance_repository.dart';
import 'package:attendance_budget_app/domain/usecases/reports/compare_companies_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

/// مستودع بديل يعيد سجلات لكل جهة على حدة.
class _FakeRepository implements AttendanceRepository {
  _FakeRepository(this._byCompany);

  final Map<int, List<AttendanceEntity>> _byCompany;

  @override
  Future<List<AttendanceEntity>> getRecordsForCompany(
          int companyId, DateTime from, DateTime to) async =>
      _byCompany[companyId] ?? const [];

  @override
  Future<AttendanceEntity?> getTodayRecord() async => null;
  @override
  Future<AttendanceEntity?> getAnyOpenSession() async => null;
  @override
  Future<List<AttendanceEntity>> getMonthlyRecords(int y, int m) async => const [];
  @override
  Future<List<AttendanceEntity>> getRecordsBetween(DateTime f, DateTime t) async => const [];
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

CompanyEntity _company(int id, String name, double salary, int hoursPerDay) {
  return CompanyEntity(
    id: id,
    name: name,
    jobTitle: 'موظف',
    baseMonthlySalary: salary,
    hourlyRate: 0,
    overtimeRate: 1.5,
    workSchedule: [
      for (int day = 0; day < 5; day++)
        WorkDayConfigEntity(
          dayOfWeek: day,
          isWorkingDay: true,
          requiredHours: hoursPerDay,
          requiredMinutes: 0,
          isHoliday: false,
        ),
    ],
    adjustments: const [],
    currency: 'ر.ي',
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );
}

AttendanceEntity _record(int companyId, int day, int workedMinutes) {
  final date = DateTime(2026, 2, day);
  return AttendanceEntity(
    id: companyId * 100 + day,
    companyId: companyId,
    date: date,
    sessions: [
      WorkSessionEntity(
          checkIn: date, checkOut: date.add(Duration(minutes: workedMinutes))),
    ],
    totalPresenceMinutes: workedMinutes,
    sessionCount: 1,
    workedHours: workedMinutes ~/ 60,
    workedMinutes: workedMinutes % 60,
    requiredHours: 8,
    requiredMinutes: 0,
    overtimeHours: 0,
    overtimeMinutes: 0,
    overtimeValue: 0,
    deficitHours: 0,
    deficitMinutes: 0,
    deficitValue: 0,
    isBiometricVerified: true,
    dayType: 'regular',
  );
}

void main() {
  final period = ReportPeriod.month(DateTime(2026, 2, 15));

  test('الترتيب بالعائد للساعة لا بالراتب المطلق', () async {
    // «الكبيرة» راتبها ضعف «الصغيرة» لكنها تأخذ أربعة أضعاف الساعات.
    final big = _company(1, 'الكبيرة', 4000, 8);
    final small = _company(2, 'الصغيرة', 2000, 4);

    final result = await CompareCompaniesUseCase(_FakeRepository({
      1: [for (int d = 1; d <= 20; d++) _record(1, d, 480)],
      2: [for (int d = 1; d <= 5; d++) _record(2, d, 240)],
    }))(companies: [big, small], period: period);

    expect(result.first.company.name, 'الصغيرة',
        reason: 'الأعلى عائداً للساعة يتصدّر، لا الأعلى راتباً');
    expect(result.first.effectiveHourlyRate,
        greaterThan(result.last.effectiveHourlyRate));
  });

  test('جهة بلا ساعات عائدها صفر ولا تقسم على صفر', () async {
    final idle = _company(3, 'خاملة', 3000, 8);

    final result = await CompareCompaniesUseCase(_FakeRepository(const {}))(
        companies: [idle], period: period);

    expect(result.single.presenceMinutes, 0);
    expect(result.single.effectiveHourlyRate, 0);
  });

  test('كل جهة تُجمّع سجلاتها هي فقط', () async {
    final a = _company(1, 'أ', 3000, 8);
    final b = _company(2, 'ب', 3000, 8);

    final result = await CompareCompaniesUseCase(_FakeRepository({
      1: [_record(1, 1, 480), _record(1, 2, 480)],
      2: [_record(2, 1, 240)],
    }))(companies: [a, b], period: period);

    final forA = result.firstWhere((e) => e.company.id == 1);
    final forB = result.firstWhere((e) => e.company.id == 2);

    expect(forA.workedMinutes, 960);
    expect(forA.attendedDays, 2);
    expect(forB.workedMinutes, 240);
    expect(forB.attendedDays, 1);
  });
}
