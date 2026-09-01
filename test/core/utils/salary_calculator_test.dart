import 'package:attendance_budget_app/core/utils/salary_calculator.dart';
import 'package:attendance_budget_app/domain/entities/profile_entity.dart';
import 'package:flutter_test/flutter_test.dart';

ProfileEntity _profile({
  double baseSalary = 3200,
  double hourlyRate = 20,
  double overtimeRate = 1.5,
  String? startTime,
  String? endTime,
}) {
  return ProfileEntity(
    id: 0,
    fullName: 'موظف',
    jobTitle: 'مطوّر',
    baseMonthlySalary: baseSalary,
    hourlyRate: hourlyRate,
    overtimeRate: overtimeRate,
    workSchedule: [
      for (int day = 0; day < 7; day++)
        WorkDayConfigEntity(
          dayOfWeek: day,
          isWorkingDay: day != 6,
          requiredHours: 8,
          requiredMinutes: 0,
          isHoliday: day == 6,
          startTime: startTime,
          endTime: endTime,
        ),
    ],
    adjustments: const [],
    updatedAt: DateTime(2026, 1, 1),
  );
}

void main() {
  group('calculateShiftDetails بدون نافذة وردية', () {
    test('يحتسب الساعات الفعلية بدل إرجاع أصفار', () {
      final calculator = SalaryCalculator(_profile());

      final details = calculator.calculateShiftDetails(
        actualCheckIn: DateTime(2026, 3, 2, 8),
        actualCheckOut: DateTime(2026, 3, 2, 16),
        scheduledStart: null,
        scheduledEnd: null,
        isCrossDay: false,
        requiredHours: 8,
        requiredMinutes: 0,
      );

      expect(details.officialMinutes, 480);
      expect(details.overtimeMinutes, 0);
      expect(details.deficitMinutes, 0);
    });

    test('الزائد عن المطلوب يُحتسب إضافياً', () {
      final calculator = SalaryCalculator(_profile());

      final details = calculator.calculateShiftDetails(
        actualCheckIn: DateTime(2026, 3, 2, 8),
        actualCheckOut: DateTime(2026, 3, 2, 18, 30),
        scheduledStart: null,
        scheduledEnd: null,
        isCrossDay: false,
        requiredHours: 8,
        requiredMinutes: 0,
      );

      expect(details.officialMinutes, 480);
      expect(details.overtimeMinutes, 150);
      expect(details.deficitMinutes, 0);
    });

    test('الناقص عن المطلوب يُحتسب عجزاً', () {
      final calculator = SalaryCalculator(_profile());

      final details = calculator.calculateShiftDetails(
        actualCheckIn: DateTime(2026, 3, 2, 9),
        actualCheckOut: DateTime(2026, 3, 2, 14),
        scheduledStart: null,
        scheduledEnd: null,
        isCrossDay: false,
        requiredHours: 8,
        requiredMinutes: 0,
      );

      expect(details.officialMinutes, 300);
      expect(details.overtimeMinutes, 0);
      expect(details.deficitMinutes, 180);
    });
  });

  group('calculateShiftDetails مع نافذة وردية', () {
    test('التواجد داخل النافذة رسمي وخارجها إضافي', () {
      final calculator =
          SalaryCalculator(_profile(startTime: '09:00', endTime: '17:00'));

      final details = calculator.calculateShiftDetails(
        actualCheckIn: DateTime(2026, 3, 2, 8, 30),
        actualCheckOut: DateTime(2026, 3, 2, 18),
        scheduledStart: '09:00',
        scheduledEnd: '17:00',
        isCrossDay: false,
        requiredHours: 8,
        requiredMinutes: 0,
      );

      expect(details.officialMinutes, 480);
      expect(details.overtimeMinutes, 90);
      expect(details.deficitMinutes, 0);
    });

    test('التأخر داخل النافذة يُحتسب عجزاً', () {
      final calculator =
          SalaryCalculator(_profile(startTime: '09:00', endTime: '17:00'));

      final details = calculator.calculateShiftDetails(
        actualCheckIn: DateTime(2026, 3, 2, 10),
        actualCheckOut: DateTime(2026, 3, 2, 17),
        scheduledStart: '09:00',
        scheduledEnd: '17:00',
        isCrossDay: false,
        requiredHours: 8,
        requiredMinutes: 0,
      );

      expect(details.officialMinutes, 420);
      expect(details.deficitMinutes, 60);
      expect(details.overtimeMinutes, 0);
    });

    test('الوردية العابرة لمنتصف الليل تمتد لليوم التالي', () {
      final calculator =
          SalaryCalculator(_profile(startTime: '22:00', endTime: '06:00'));

      final details = calculator.calculateShiftDetails(
        actualCheckIn: DateTime(2026, 3, 2, 22),
        actualCheckOut: DateTime(2026, 3, 3, 6),
        scheduledStart: '22:00',
        scheduledEnd: '06:00',
        isCrossDay: true,
        requiredHours: 8,
        requiredMinutes: 0,
      );

      expect(details.officialMinutes, 480);
      expect(details.deficitMinutes, 0);
      expect(details.overtimeMinutes, 0);
    });
  });

  group('أجر الساعة', () {
    test('السعر اليدوي له الأولوية', () {
      expect(SalaryCalculator(_profile(hourlyRate: 25)).hourlyWage, 25);
    });

    test('بدون سعر يدوي يُشتق من الراتب والجدول الأسبوعي', () {
      // ستة أيام × ٨ ساعات × 4.33 أسبوع = 207.84 ساعة شهرياً
      final calculator = SalaryCalculator(_profile(hourlyRate: 0));
      expect(calculator.hourlyWage, closeTo(3200 / 207.84, 0.01));
    });

    test('overtimeRate فوق ٢ يُعامل كسعر مطلق لا كمضاعف', () {
      final calculator =
          SalaryCalculator(_profile(hourlyRate: 20, overtimeRate: 35));
      expect(calculator.overtimeHourlyRate, 35);
    });

    test('overtimeRate حتى ٢ يُعامل كمضاعف', () {
      final calculator =
          SalaryCalculator(_profile(hourlyRate: 20, overtimeRate: 1.5));
      expect(calculator.overtimeHourlyRate, 30);
    });
  });
}
