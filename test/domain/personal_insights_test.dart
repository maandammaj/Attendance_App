import 'package:attendance_budget_app/domain/entities/company_entity.dart';
import 'package:attendance_budget_app/domain/entities/leave_entity.dart';
import 'package:attendance_budget_app/domain/entities/payroll_entity.dart';
import 'package:attendance_budget_app/domain/entities/personal_insight_entity.dart';
import 'package:attendance_budget_app/domain/usecases/reports/build_personal_insights_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

CompanyEntity _company(int id, String name) => CompanyEntity(
      id: id,
      name: name,
      jobTitle: 'موظف',
      baseMonthlySalary: 0,
      hourlyRate: 10,
      overtimeRate: 1.5,
      workSchedule: const [],
      adjustments: const [],
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

WorkplacePayroll _wp({
  required int id,
  required String name,
  required double basic,
  int workedMinutes = 60 * 100,
  int overtimeMinutes = 0,
}) =>
    WorkplacePayroll(
      company: _company(id, name),
      basic: basic,
      overtime: 0,
      deductions: 0,
      adjustments: 0,
      workedMinutes: workedMinutes,
      overtimeMinutes: overtimeMinutes,
      attendedDays: 20,
    );

PersonalPayroll _payroll(List<WorkplacePayroll> workplaces) => PersonalPayroll(
      from: DateTime(2026, 9, 1),
      to: DateTime(2026, 9, 30),
      workplaces: [...workplaces]..sort((a, b) => b.net.compareTo(a.net)),
    );

const _useCase = BuildPersonalInsightsUseCase();

void main() {
  group('تغيّر الدخل', () {
    test('زيادة مادّية تُذكر بنسبتها', () {
      final insights = _useCase(
        current: _payroll([_wp(id: 1, name: 'أ', basic: 11800)]),
        previous: _payroll([_wp(id: 1, name: 'أ', basic: 10000)]),
      );
      expect(insights.any((i) => i.message.contains('18٪')), isTrue);
      expect(insights.first.tone, InsightTone.positive);
    });

    test('تغيّر دون العتبة لا يُذكر', () {
      final insights = _useCase(
        current: _payroll([_wp(id: 1, name: 'أ', basic: 10200)]),
        previous: _payroll([_wp(id: 1, name: 'أ', basic: 10000)]),
      );
      expect(insights, isEmpty, reason: 'انطلقت رؤية على ضجيج 2٪');
    });

    test('أساس صفري لا يُقارَن به', () {
      // «زاد ما لا نهاية بالمئة» ليس معلومة.
      final insights = _useCase(
        current: _payroll([_wp(id: 1, name: 'أ', basic: 5000)]),
        previous: _payroll([_wp(id: 1, name: 'أ', basic: 0)]),
      );
      expect(insights, isEmpty);
    });

    test('بلا شهر سابق لا مقارنة', () {
      final insights = _useCase(
        current: _payroll([_wp(id: 1, name: 'أ', basic: 5000)]),
      );
      expect(insights, isEmpty);
    });
  });

  group('الإضافي', () {
    test('زيادة تتجاوز نصف ساعة تُذكر', () {
      final insights = _useCase(
        current: _payroll(
            [_wp(id: 1, name: 'أ', basic: 5000, overtimeMinutes: 144)]),
        previous: _payroll([_wp(id: 1, name: 'أ', basic: 5000)]),
      );
      expect(insights.any((i) => i.message.contains('2.4 ساعة')), isTrue);
    });

    test('زيادة عشر دقائق لا تُذكر', () {
      final insights = _useCase(
        current: _payroll(
            [_wp(id: 1, name: 'أ', basic: 5000, overtimeMinutes: 10)]),
        previous: _payroll([_wp(id: 1, name: 'أ', basic: 5000)]),
      );
      expect(insights.any((i) => i.message.contains('إضافيك')), isFalse);
    });

    test('زيادة الإضافي محايدة لا إيجابية', () {
      // مالٌ أكثر ووقتٌ أقلّ — ليست خبراً ساراً بالضرورة.
      final insights = _useCase(
        current: _payroll(
            [_wp(id: 1, name: 'أ', basic: 5000, overtimeMinutes: 300)]),
        previous: _payroll([_wp(id: 1, name: 'أ', basic: 5000)]),
      );
      final overtime = insights.firstWhere((i) => i.message.contains('إضافيك'));
      expect(overtime.tone, InsightTone.neutral);
    });
  });

  group('العائد للساعة', () {
    test('تُذكر حين تخالف الجهة الأعلى دخلاً الأعلى عائداً', () {
      // أ: 8000 عن 160 ساعة = 50 · ب: 4000 عن 20 ساعة = 200
      final insights = _useCase(
        current: _payroll([
          _wp(id: 1, name: 'أ', basic: 8000, workedMinutes: 160 * 60),
          _wp(id: 2, name: 'ب', basic: 4000, workedMinutes: 20 * 60),
        ]),
      );
      final divergence =
          insights.firstWhere((i) => i.message.contains('لكل ساعة'));
      expect(divergence.message, contains('«أ»'));
      expect(divergence.message, contains('«ب»'));
    });

    test('لا تُذكر حين تكون الجهة نفسها', () {
      final insights = _useCase(
        current: _payroll([
          _wp(id: 1, name: 'أ', basic: 8000, workedMinutes: 20 * 60),
          _wp(id: 2, name: 'ب', basic: 1000, workedMinutes: 160 * 60),
        ]),
      );
      expect(insights.any((i) => i.message.contains('لكل ساعة')), isFalse);
    });

    test('بجهة واحدة لا مقارنة', () {
      final insights = _useCase(
        current: _payroll([_wp(id: 1, name: 'أ', basic: 8000)]),
      );
      expect(insights.any((i) => i.message.contains('لكل ساعة')), isFalse);
    });
  });

  group('الإجازات', () {
    test('التجاوز يُذكر سلبياً', () {
      final insights = _useCase(
        current: _payroll([_wp(id: 1, name: 'أ', basic: 5000)]),
        leaveBalances: const [
          LeaveBalanceEntity(
              type: LeaveTypeEntity.annual, allowance: 20, used: 23),
        ],
      );
      final leave = insights.firstWhere((i) => i.message.contains('تجاوزت'));
      expect(leave.tone, InsightTone.negative);
      expect(leave.message, contains('3 يوم'));
    });

    test('الاقتراب من الرصيد يُذكر', () {
      final insights = _useCase(
        current: _payroll([_wp(id: 1, name: 'أ', basic: 5000)]),
        leaveBalances: const [
          LeaveBalanceEntity(
              type: LeaveTypeEntity.annual, allowance: 20, used: 17),
        ],
      );
      expect(insights.any((i) => i.message.contains('بقي 3 يوم')), isTrue);
    });

    test('استهلاك معتدل لا يُذكر', () {
      final insights = _useCase(
        current: _payroll([_wp(id: 1, name: 'أ', basic: 5000)]),
        leaveBalances: const [
          LeaveBalanceEntity(
              type: LeaveTypeEntity.annual, allowance: 20, used: 5),
        ],
      );
      expect(insights, isEmpty);
    });

    test('رصيد غير مُعلَن لا يُذكر', () {
      final insights = _useCase(
        current: _payroll([_wp(id: 1, name: 'أ', basic: 5000)]),
        leaveBalances: const [
          LeaveBalanceEntity(
              type: LeaveTypeEntity.sick, allowance: 0, used: 9),
        ],
      );
      expect(insights, isEmpty);
    });
  });
}
