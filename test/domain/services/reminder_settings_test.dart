import 'package:attendance_budget_app/domain/entities/reminder_settings_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ساعات الهدوء', () {
    test('معطّلة افتراضياً فلا تكتم شيئاً', () {
      const settings = ReminderSettingsEntity();
      expect(settings.isQuietAt(DateTime(2026, 3, 2, 2)), isFalse);
    });

    test('نافذة عابرة لمنتصف الليل تكتم قبله وبعده', () {
      const settings = ReminderSettingsEntity(
        quietHoursEnabled: true,
        quietHoursStart: '23:00',
        quietHoursEnd: '07:00',
      );

      expect(settings.isQuietAt(DateTime(2026, 3, 2, 23, 30)), isTrue);
      expect(settings.isQuietAt(DateTime(2026, 3, 2, 3)), isTrue);
      expect(settings.isQuietAt(DateTime(2026, 3, 2, 6, 59)), isTrue);
      expect(settings.isQuietAt(DateTime(2026, 3, 2, 7)), isFalse);
      expect(settings.isQuietAt(DateTime(2026, 3, 2, 14)), isFalse);
    });

    test('نافذة داخل اليوم نفسه لا تلتف', () {
      const settings = ReminderSettingsEntity(
        quietHoursEnabled: true,
        quietHoursStart: '13:00',
        quietHoursEnd: '16:00',
      );

      expect(settings.isQuietAt(DateTime(2026, 3, 2, 14)), isTrue);
      expect(settings.isQuietAt(DateTime(2026, 3, 2, 12, 59)), isFalse);
      expect(settings.isQuietAt(DateTime(2026, 3, 2, 16)), isFalse);
      expect(settings.isQuietAt(DateTime(2026, 3, 2, 23)), isFalse);
    });
  });

  group('copyWith', () {
    test('يبدّل الحقل المطلوب ويترك الباقي', () {
      const settings = ReminderSettingsEntity();
      final updated = settings.copyWith(shiftStartLeadMinutes: 45);

      expect(updated.shiftStartLeadMinutes, 45);
      expect(updated.shiftEndLeadMinutes, settings.shiftEndLeadMinutes);
      expect(updated.dailySummaryTime, settings.dailySummaryTime);
      expect(updated.debtDueLeadDays, settings.debtDueLeadDays);
    });
  });
}
