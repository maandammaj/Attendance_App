import 'package:attendance_budget_app/domain/entities/company_entity.dart';
import 'package:attendance_budget_app/domain/entities/profile_entity.dart';
import 'package:attendance_budget_app/domain/services/attendance_calculation_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// وردية 08:00–16:00 بأجر ساعة 10 ومعامل إضافي 1.5.
CompanyEntity _company({WorkPolicyEntity policy = const WorkPolicyEntity()}) =>
    CompanyEntity(
      id: 1,
      name: 'جهة',
      jobTitle: 'موظف',
      baseMonthlySalary: 0,
      hourlyRate: 10,
      overtimeRate: 1.5,
      workSchedule: const [],
      adjustments: const [],
      policy: policy,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

const _day = WorkDayConfigEntity(
  dayOfWeek: DateTime.monday,
  isWorkingDay: true,
  requiredHours: 8,
  requiredMinutes: 0,
  isHoliday: false,
  startTime: '08:00',
  endTime: '16:00',
);

DayCalculation _run({
  required int fromHour,
  required int fromMinute,
  required int toHour,
  int toMinute = 0,
  WorkPolicyEntity policy = const WorkPolicyEntity(),
}) {
  return const AttendanceCalculationService()(
    sessions: [
      SessionInput(
        checkIn: DateTime(2026, 9, 7, fromHour, fromMinute),
        checkOut: DateTime(2026, 9, 7, toHour, toMinute),
      ),
    ],
    company: _company(policy: policy),
    dayConfig: _day,
    isAbsent: false,
  );
}

void main() {
  group('فترة السماح', () {
    test('تأخّر داخل السماح لا يُخصم', () {
      // وصل 08:07 وانصرف 16:00 — عجز سبع دقائق، والسماح عشر.
      final result = _run(
        fromHour: 8, fromMinute: 7, toHour: 16,
        policy: const WorkPolicyEntity(graceMinutes: 10),
      );
      expect(result.deficitMinutes, 0);
      expect(result.deficitValue, 0);
    });

    test('تأخّر يتجاوز السماح يُخصم كاملاً لا الفارق', () {
      // عجز 20 دقيقة والسماح 10: السماح إعفاء لا حسم.
      final result = _run(
        fromHour: 8, fromMinute: 20, toHour: 16,
        policy: const WorkPolicyEntity(graceMinutes: 10),
      );
      expect(result.deficitMinutes, 20);
      expect(result.deficitValue, closeTo(20 / 60 * 10, 0.001));
    });

    test('بلا سماح يُخصم كل تأخّر', () {
      final result = _run(fromHour: 8, fromMinute: 7, toHour: 16);
      expect(result.deficitMinutes, 7);
    });
  });

  group('أقلّ إضافي يُعتدّ به', () {
    test('إضافي دون الحدّ يسقط', () {
      // بقي خمس دقائق بعد 16:00 والحدّ خمس عشرة.
      final result = _run(
        fromHour: 8, fromMinute: 0, toHour: 16, toMinute: 5,
        policy: const WorkPolicyEntity(minOvertimeMinutes: 15),
      );
      expect(result.overtimeMinutes, 0);
      expect(result.overtimeValue, 0);
    });

    test('إضافي يبلغ الحدّ يُحتسب كاملاً', () {
      final result = _run(
        fromHour: 8, fromMinute: 0, toHour: 16, toMinute: 30,
        policy: const WorkPolicyEntity(minOvertimeMinutes: 15),
      );
      expect(result.overtimeMinutes, 30);
      expect(result.overtimeValue, closeTo(30 / 60 * 15, 0.001));
    });
  });

  group('جهة لا تدفع الإضافي', () {
    test('الدقائق تُعرض والأجر صفر', () {
      final result = _run(
        fromHour: 8, fromMinute: 0, toHour: 18,
        policy: const WorkPolicyEntity(paysOvertime: false),
      );
      expect(result.overtimeMinutes, 120,
          reason: 'أُخفيت ساعتان عملهما المستخدم فعلاً');
      expect(result.overtimeValue, 0);
    });

    test('الافتراضي أن الإضافي مدفوع', () {
      final result = _run(fromHour: 8, fromMinute: 0, toHour: 18);
      expect(result.overtimeMinutes, 120);
      expect(result.overtimeValue, closeTo(2 * 15, 0.001));
    });
  });

  test('السياسة الافتراضية لا تغيّر شيئاً', () {
    final withDefault = _run(fromHour: 8, fromMinute: 12, toHour: 17);
    final explicit = _run(
      fromHour: 8, fromMinute: 12, toHour: 17,
      policy: const WorkPolicyEntity(),
    );
    expect(withDefault.deficitMinutes, explicit.deficitMinutes);
    expect(withDefault.overtimeValue, explicit.overtimeValue);
  });
}
