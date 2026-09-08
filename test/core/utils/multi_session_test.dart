import 'package:attendance_budget_app/core/utils/salary_calculator.dart';
import 'package:attendance_budget_app/domain/entities/attendance_entity.dart';
import 'package:attendance_budget_app/domain/entities/company_entity.dart';
import 'package:attendance_budget_app/domain/entities/profile_entity.dart';
import 'package:flutter_test/flutter_test.dart';

CompanyEntity _company({String? startTime, String? endTime}) {
  return CompanyEntity(
    id: 1,
    name: 'جهة',
    jobTitle: 'مطوّر',
    baseMonthlySalary: 3200,
    hourlyRate: 20,
    overtimeRate: 1.5,
    workSchedule: [
      for (int day = 1; day <= 7; day++)
        WorkDayConfigEntity(
          dayOfWeek: day,
          isWorkingDay: day != DateTime.friday,
          requiredHours: 8,
          requiredMinutes: 0,
          isHoliday: day == DateTime.friday,
          startTime: startTime,
          endTime: endTime,
        ),
    ],
    adjustments: const [],
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026, 1, 1),
  );
}

({DateTime start, DateTime end}) _session(int fromHour, int toHour) =>
    SalaryCalculator.presence(
      DateTime(2026, 3, 2, fromHour),
      DateTime(2026, 3, 2, toHour),
    );

void main() {
  group('يوم بعدة جلسات بلا نافذة وردية', () {
    test('يجمع مدد الجلسات كلها', () {
      final details = SalaryCalculator(_company()).calculateDayDetails(
        sessions: [_session(8, 12), _session(13, 17)],
        scheduledStart: null,
        scheduledEnd: null,
        isCrossDay: false,
        requiredHours: 8,
      );

      expect(details.officialMinutes, 480);
      expect(details.overtimeMinutes, 0);
      expect(details.deficitMinutes, 0);
    });

    test('مجموع أقل من المطلوب يعطي عجزاً', () {
      final details = SalaryCalculator(_company()).calculateDayDetails(
        sessions: [_session(8, 10), _session(14, 16)],
        scheduledStart: null,
        scheduledEnd: null,
        isCrossDay: false,
        requiredHours: 8,
      );

      expect(details.officialMinutes, 240);
      expect(details.deficitMinutes, 240);
      expect(details.overtimeMinutes, 0);
    });

    test('يوم بلا جلسات كله عجز', () {
      final details = SalaryCalculator(_company()).calculateDayDetails(
        sessions: const [],
        scheduledStart: null,
        scheduledEnd: null,
        isCrossDay: false,
        requiredHours: 8,
      );

      expect(details.officialMinutes, 0);
      expect(details.deficitMinutes, 480);
    });
  });

  group('يوم بعدة جلسات داخل نافذة وردية', () {
    test('الانقطاع داخل النافذة يُحتسب عجزاً', () {
      // النافذة 09–17، والخروج بين 12 و13 يترك ساعة غير مغطاة.
      final details =
          SalaryCalculator(_company(startTime: '09:00', endTime: '17:00'))
              .calculateDayDetails(
        sessions: [_session(9, 12), _session(13, 17)],
        scheduledStart: '09:00',
        scheduledEnd: '17:00',
        isCrossDay: false,
        requiredHours: 8,
      );

      expect(details.officialMinutes, 420);
      expect(details.deficitMinutes, 60);
      expect(details.overtimeMinutes, 0);
    });

    test('جلسة خارج النافذة كلها إضافي', () {
      final details =
          SalaryCalculator(_company(startTime: '09:00', endTime: '17:00'))
              .calculateDayDetails(
        sessions: [_session(9, 17), _session(19, 21)],
        scheduledStart: '09:00',
        scheduledEnd: '17:00',
        isCrossDay: false,
        requiredHours: 8,
      );

      expect(details.officialMinutes, 480);
      expect(details.overtimeMinutes, 120);
      expect(details.deficitMinutes, 0);
    });
  });

  group('AttendanceEntity', () {
    final now = DateTime(2026, 3, 2, 15);

    test('presenceMinutesAt يشمل الجلسة المفتوحة', () {
      final entity = AttendanceEntity(
        id: 1,
        date: _anyDate,
        sessions: [
          WorkSessionEntity(checkIn: _at8, checkOut: _at12),
          WorkSessionEntity(checkIn: _at13),
        ],
        isOpen: true,
        workedHours: 0,
        workedMinutes: 0,
        requiredHours: 8,
        requiredMinutes: 0,
        overtimeHours: 0,
        overtimeMinutes: 0,
        overtimeValue: 0,
        deficitHours: 0,
        deficitMinutes: 0,
        deficitValue: 0,
        isBiometricVerified: false,
        dayType: 'regular',
      );

      // 4 ساعات مغلقة + ساعتان من الجلسة المفتوحة حتى الساعة 15.
      expect(entity.presenceMinutesAt(now), 360);
      expect(entity.openSession, isNotNull);
    });

    test('openSession فارغ حين لا جلسة مفتوحة', () {
      final entity = AttendanceEntity(
        id: 1,
        date: _anyDate,
        sessions: [WorkSessionEntity(checkIn: _at8, checkOut: _at12)],
        workedHours: 0,
        workedMinutes: 0,
        requiredHours: 8,
        requiredMinutes: 0,
        overtimeHours: 0,
        overtimeMinutes: 0,
        overtimeValue: 0,
        deficitHours: 0,
        deficitMinutes: 0,
        deficitValue: 0,
        isBiometricVerified: false,
        dayType: 'regular',
      );

      expect(entity.openSession, isNull);
      expect(entity.presenceMinutesAt(now), 240);
    });
  });

  group('تخصيص أيام الدوام', () {
    test('windowMinutes يحسب الوردية الليلية عبر منتصف الليل', () {
      const night = WorkDayConfigEntity(
        dayOfWeek: DateTime.monday,
        isWorkingDay: true,
        requiredHours: 8,
        requiredMinutes: 0,
        isHoliday: false,
        startTime: '22:00',
        endTime: '06:00',
        isCrossDay: true,
      );
      expect(night.windowMinutes, 480);
    });

    test('copyWith بـ clearWindow يمسح النافذة والامتداد معاً', () {
      const day = WorkDayConfigEntity(
        dayOfWeek: DateTime.monday,
        isWorkingDay: true,
        requiredHours: 8,
        requiredMinutes: 0,
        isHoliday: false,
        startTime: '22:00',
        endTime: '06:00',
        isCrossDay: true,
      );

      final cleared = day.copyWith(clearWindow: true);
      expect(cleared.hasShiftWindow, isFalse);
      expect(cleared.isCrossDay, isFalse);
      expect(cleared.requiredHours, 8);
    });
  });
}

final _anyDate = DateTime(2026, 3, 2);
final _at8 = DateTime(2026, 3, 2, 8);
final _at12 = DateTime(2026, 3, 2, 12);
final _at13 = DateTime(2026, 3, 2, 13);
