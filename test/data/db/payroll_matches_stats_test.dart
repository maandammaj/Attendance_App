import 'package:attendance_budget_app/core/utils/clock.dart';
import 'package:attendance_budget_app/data/local/repositories/attendance_repository_impl.dart';
import 'package:attendance_budget_app/data/local/repositories/company_repository_impl.dart';
import 'package:attendance_budget_app/domain/services/month_absence_service.dart';
import 'package:attendance_budget_app/domain/usecases/attendance/get_monthly_stats_usecase.dart';
import 'package:attendance_budget_app/domain/usecases/payroll/build_personal_payroll_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_database.dart';

void main() {
  late TestDatabase db;

  // شهر منقضٍ بالكامل حتى لا تتغيّر النتيجة بتغيّر اليوم.
  final clock = FakeClock(DateTime(2026, 8, 1));
  const year = 2026;
  const month = 7;

  setUp(() async => db = await TestDatabase.open());
  tearDown(() async => db.close());

  test('شاشة الدخل وشاشة الدوام تتفقان على خصم الغياب', () async {
    final id = await db.addCompany(
      name: 'أ',
      hourlyRate: 10,
      hoursPerDay: 8,
      baseMonthlySalary: 3000,
      startTime: '08:00',
      endTime: '16:00',
    );
    await db.setActiveCompany(id);

    final attendance = AttendanceRepositoryImpl();
    // يوم واحد فقط من شهر كامل — الباقي غياب.
    await attendance.addManualRecord(
      date: DateTime(2026, 7, 6),
      checkIn: DateTime(2026, 7, 6, 8),
      checkOut: DateTime(2026, 7, 6, 16),
    );

    final company = (await CompanyRepositoryImpl().getById(id))!;

    final stats = await GetMonthlyStatsUseCase(attendance, clock: clock)(
        year, month, company);

    final payroll = await BuildPersonalPayrollUseCase(
      attendance,
      absenceService: MonthAbsenceService(clock: clock),
    )(
      companies: [company],
      from: DateTime(year, month, 1),
      to: DateTime(year, month + 1, 0, 23, 59, 59),
    );

    // الغياب حقيقي في هذا الشهر — وإلا لما اختبرنا شيئاً.
    expect(stats.totalDeficitValue, greaterThan(0));

    expect(payroll.workplaces.single.deductions,
        closeTo(stats.totalDeficitValue, 0.001),
        reason: 'شاشة الدخل تتجاهل الغياب فتُظهر راتباً أعلى من المستحق');

    // والصافي يطابق ما تعرضه اللوحة: الأساسي ناقص الخصم.
    expect(payroll.totalNet,
        closeTo(3000 - stats.totalDeficitValue, 0.001));
  });
}
