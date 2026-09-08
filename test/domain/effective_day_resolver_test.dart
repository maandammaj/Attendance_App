import 'package:attendance_budget_app/domain/entities/calendar_day_entity.dart';
import 'package:attendance_budget_app/domain/entities/profile_entity.dart';
import 'package:attendance_budget_app/domain/services/effective_day_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

CalendarDayEntity _entry({
  int? companyId,
  required CalendarDayKindEntity kind,
  int id = 1,
}) =>
    CalendarDayEntity(
      id: id,
      companyId: companyId,
      date: DateTime(2026, 9, 26),
      kind: kind,
      createdAt: DateTime(2026),
    );

const _workday = WorkDayConfigEntity(
  dayOfWeek: DateTime.saturday,
  isWorkingDay: true,
  requiredHours: 8,
  requiredMinutes: 0,
  isHoliday: false,
  startTime: '08:00',
  endTime: '16:00',
);

const _dayOff = WorkDayConfigEntity(
  dayOfWeek: DateTime.friday,
  isWorkingDay: false,
  requiredHours: 0,
  requiredMinutes: 0,
  isHoliday: true,
);

void main() {
  group('الأخصّ يغلب', () {
    test('إدخال الجهة يسبق الإدخال العام', () {
      final entries = [
        _entry(kind: CalendarDayKindEntity.publicHoliday, id: 1),
        _entry(
            companyId: 7,
            kind: CalendarDayKindEntity.specialWorkday,
            id: 2),
      ];
      expect(EffectiveDayResolver.governing(entries, 7)!.id, 2);
    });

    test('جهة بلا إدخال خاص تأخذ العام', () {
      final entries = [
        _entry(kind: CalendarDayKindEntity.publicHoliday, id: 1),
        _entry(companyId: 7, kind: CalendarDayKindEntity.specialWorkday, id: 2),
      ];
      expect(EffectiveDayResolver.governing(entries, 99)!.id, 1);
    });

    test('بلا إدخالات لا حاكم', () {
      expect(EffectiveDayResolver.governing(const [], 7), isNull);
    });
  });

  group('أثر العطلة على إعداد اليوم', () {
    test('العطلة تُفرِّغ المطلوب ونافذة الوردية', () {
      final result = EffectiveDayResolver.apply(
        base: _workday,
        entry: _entry(kind: CalendarDayKindEntity.publicHoliday),
      );
      expect(result.isWorkingDay, isFalse);
      expect(result.isHoliday, isTrue);
      expect(result.requiredMinutesTotal, 0);
      // بلا تفريغ النافذة يبقى اليوم يحسب عجزاً عن ساعات لم تُطلَب.
      expect(result.hasShiftWindow, isFalse);
    });

    test('عطلة الجهة كالعطلة الرسمية في الأثر', () {
      final result = EffectiveDayResolver.apply(
        base: _workday,
        entry: _entry(kind: CalendarDayKindEntity.workplaceHoliday),
      );
      expect(result.requiredMinutesTotal, 0);
      expect(result.isWorkingDay, isFalse);
    });
  });

  group('الدوام الاستثنائي', () {
    test('يفتح يوم راحة بثماني ساعات', () {
      final result = EffectiveDayResolver.apply(
        base: _dayOff,
        entry: _entry(kind: CalendarDayKindEntity.specialWorkday),
      );
      expect(result.isWorkingDay, isTrue);
      expect(result.isHoliday, isFalse);
      expect(result.requiredMinutesTotal, 480);
    });

    test('يحترم ساعات اليوم إن كانت مُعرَّفة', () {
      const halfDay = WorkDayConfigEntity(
        dayOfWeek: DateTime.friday,
        isWorkingDay: false,
        requiredHours: 4,
        requiredMinutes: 0,
        isHoliday: true,
      );
      final result = EffectiveDayResolver.apply(
        base: halfDay,
        entry: _entry(kind: CalendarDayKindEntity.specialWorkday),
      );
      expect(result.requiredMinutesTotal, 240);
    });
  });

  test('بلا إدخال يبقى الجدول كما هو', () {
    final result = EffectiveDayResolver.apply(base: _workday, entry: null);
    expect(result.requiredMinutesTotal, 480);
    expect(result.hasShiftWindow, isTrue);
  });
}
