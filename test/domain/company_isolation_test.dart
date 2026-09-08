import 'package:attendance_budget_app/core/utils/salary_calculator.dart';
import 'package:attendance_budget_app/domain/entities/company_entity.dart';
import 'package:attendance_budget_app/domain/entities/profile_entity.dart';
import 'package:flutter_test/flutter_test.dart';

CompanyEntity _company({
  required String name,
  required double salary,
  required int hoursPerDay,
  double overtimeRate = 1.5,
  double hourlyRate = 0,
}) {
  return CompanyEntity(
    id: name.hashCode,
    name: name,
    jobTitle: 'موظف',
    baseMonthlySalary: salary,
    hourlyRate: hourlyRate,
    overtimeRate: overtimeRate,
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

void main() {
  group('كل جهة تُحسب بشروطها', () {
    final morning = _company(name: 'الصباحية', salary: 3000, hoursPerDay: 8);
    // راتب/ساعات مختلفة النسبة عمداً: 3000/40 و1000/20 لا يتساويان.
    final evening = _company(name: 'المسائية', salary: 1000, hoursPerDay: 4);

    test('أجر الساعة يختلف باختلاف الراتب والجدول', () {
      final a = SalaryCalculator(morning).hourlyWage;
      final b = SalaryCalculator(evening).hourlyWage;

      expect(a, closeTo(3000 / (5 * 8 * 4.33), 0.01));
      expect(b, closeTo(1000 / (5 * 4 * 4.33), 0.01));
      expect(a, isNot(closeTo(b, 0.01)));
    });

    test('نفس ساعة الإضافي تُقيَّم مختلفاً في كل جهة', () {
      final a = SalaryCalculator(morning).calculateOvertimeValue(1, 0);
      final b = SalaryCalculator(evening).calculateOvertimeValue(1, 0);
      expect(a, isNot(closeTo(b, 0.01)));
    });

    test('معامل الإضافي فوق 2 يُعامَل كأجر مطلق لكل جهة على حدة', () {
      final absolute = _company(
          name: 'مطلقة', salary: 3000, hoursPerDay: 8, overtimeRate: 40);
      expect(SalaryCalculator(absolute).overtimeHourlyRate, 40);
      expect(SalaryCalculator(morning).overtimeHourlyRate,
          closeTo(SalaryCalculator(morning).hourlyWage * 1.5, 0.01));
    });

    test('أجر الساعة اليدوي يتجاوز اشتقاقه من الراتب', () {
      final manual = _company(
          name: 'يدوية', salary: 3000, hoursPerDay: 8, hourlyRate: 25);
      expect(SalaryCalculator(manual).hourlyWage, 25);
    });

    test('البدلات تخص جهتها ولا تتسرّب لغيرها', () {
      final withBonus = morning.copyWith(adjustments: [
        SalaryAdjustmentEntity(title: 'بدل نقل', amount: 200, isAddition: true),
      ]);

      final a = SalaryCalculator(withBonus).calculateMonthly(
        totalOvertimeValue: 0,
        totalDeficitValue: 0,
        totalDebtPayments: 0,
        totalTransactionsExpenses: 0,
      );
      final b = SalaryCalculator(morning).calculateMonthly(
        totalOvertimeValue: 0,
        totalDeficitValue: 0,
        totalDebtPayments: 0,
        totalTransactionsExpenses: 0,
      );

      expect(a.adjustments, 200);
      expect(b.adjustments, 0);
      expect(a.gross - b.gross, 200);
    });
  });

  test('الملف الشخصي يحمل مؤشر الجهة الفعّالة لا شروط العمل', () {
    final profile = ProfileEntity(
      id: 0,
      fullName: 'موظف',
      activeCompanyId: 7,
    );
    expect(profile.activeCompanyId, 7);
    expect(profile.copyWith(activeCompanyId: 9).activeCompanyId, 9);
  });
}
