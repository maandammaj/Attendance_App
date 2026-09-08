import 'package:attendance_budget_app/core/utils/salary_calculator.dart';
import 'package:attendance_budget_app/domain/entities/company_entity.dart';
import 'package:attendance_budget_app/domain/entities/overtime_policy_entity.dart';
import 'package:flutter_test/flutter_test.dart';

/// أجر الساعة 10 لتسهيل القراءة.
CompanyEntity _company({
  double legacyRate = 1.5,
  OvertimePolicyEntity? policy,
}) =>
    CompanyEntity(
      id: 1,
      name: 'جهة',
      jobTitle: 'موظف',
      baseMonthlySalary: 0,
      hourlyRate: 10,
      overtimeRate: legacyRate,
      workSchedule: const [],
      adjustments: const [],
      explicitOvertimePolicy: policy,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

void main() {
  group('أنواع الأجر', () {
    test('المضاعِف يضرب أجر الساعة', () {
      final rate = const OvertimeRateEntity.multiplier(1.5);
      expect(rate.amountFor(minutes: 120, hourlyWage: 10), closeTo(30, 0.001));
    });

    test('المبلغ لكل ساعة مستقلّ عن أجر الساعة', () {
      const rate =
          OvertimeRateEntity(kind: OvertimeRateKind.fixedPerHour, value: 1000);
      expect(rate.amountFor(minutes: 90, hourlyWage: 10), closeTo(1500, 0.001));
      // أجر ساعة مختلف تماماً لا يغيّر النتيجة.
      expect(rate.amountFor(minutes: 90, hourlyWage: 999),
          closeTo(1500, 0.001));
    });

    test('المبلغ لليوم لا يتضاعف بالساعات', () {
      const rate =
          OvertimeRateEntity(kind: OvertimeRateKind.fixedPerDay, value: 5000);
      expect(rate.amountFor(minutes: 60, hourlyWage: 10), 5000);
      expect(rate.amountFor(minutes: 480, hourlyWage: 10), 5000);
    });

    test('بلا دقائق لا مبلغ — حتى المقطوع لليوم', () {
      const rate =
          OvertimeRateEntity(kind: OvertimeRateKind.fixedPerDay, value: 5000);
      expect(rate.amountFor(minutes: 0, hourlyWage: 10), 0);
    });
  });

  group('الأجر يختلف بنوع اليوم', () {
    final policy = OvertimePolicyEntity(
      normal: const OvertimeRateEntity.multiplier(1.5),
      weekend: const OvertimeRateEntity.multiplier(2),
      publicHoliday: const OvertimeRateEntity.multiplier(2.5),
    );

    test('كل نوع يأخذ معدّله', () {
      final calc = SalaryCalculator(_company(policy: policy));
      expect(calc.calculateOvertimeValue(2, 0), closeTo(30, 0.001));
      expect(
          calc.calculateOvertimeValue(2, 0, dayType: OvertimeDayType.weekend),
          closeTo(40, 0.001));
      expect(
          calc.calculateOvertimeValue(2, 0,
              dayType: OvertimeDayType.publicHoliday),
          closeTo(50, 0.001));
    });

    test('نوع غير محدَّد يرجع إلى يوم العمل العادي', () {
      // عطلة الجهة لم تُحدَّد في هذه السياسة.
      final calc = SalaryCalculator(_company(policy: policy));
      expect(
          calc.calculateOvertimeValue(2, 0,
              dayType: OvertimeDayType.workplaceHoliday),
          closeTo(30, 0.001));
    });

    test('مضاعِف 2.5 صار ممكناً', () {
      // بالقاعدة القديمة كانت 2.5 تُقرأ مبلغاً مطلقاً لا مضاعِفاً.
      final calc = SalaryCalculator(
          _company(policy: OvertimePolicyEntity(
              normal: const OvertimeRateEntity.multiplier(2.5))));
      expect(calc.calculateOvertimeValue(1, 0), closeTo(25, 0.001));
    });
  });

  group('الاشتقاق من الحقل القديم يحفظ الأرقام', () {
    test('قيمة دون 2 تبقى مضاعِفاً', () {
      final calc = SalaryCalculator(_company(legacyRate: 1.5));
      expect(calc.calculateOvertimeValue(2, 0), closeTo(30, 0.001));
    });

    test('قيمة فوق 2 تبقى مبلغاً لكل ساعة', () {
      // القاعدة القديمة حرفياً: 50 تعني خمسين للساعة لا خمسين ضعفاً.
      final calc = SalaryCalculator(_company(legacyRate: 50));
      expect(calc.calculateOvertimeValue(2, 0), closeTo(100, 0.001));
    });

    test('جهة بلا سياسة صريحة تشتقّ واحدة', () {
      final company = _company(legacyRate: 1.5);
      expect(company.explicitOvertimePolicy, isNull);
      expect(company.overtimePolicy.normal.kind, OvertimeRateKind.multiplier);
      expect(company.overtimePolicy.normal.value, 1.5);
    });
  });
}
