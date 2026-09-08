import 'package:attendance_budget_app/core/utils/date_helpers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('الأسبوع يبدأ بالسبت', () {
    test('اسم اليوم صحيح لكل أيام الأسبوع', () {
      // 2026-03-07 سبت، والأيام السبعة تتوالى منه.
      const expected = [
        'السبت',
        'الأحد',
        'الاثنين',
        'الثلاثاء',
        'الأربعاء',
        'الخميس',
        'الجمعة',
      ];
      for (int i = 0; i < 7; i++) {
        expect(
          DateHelpers.getArabicDayName(DateTime(2026, 3, 7 + i)),
          expected[i],
          reason: 'يوم ${7 + i} من مارس',
        );
      }
    });

    test('scheduleDayOf يطابق ترقيم DateTime.weekday المخزَّن', () {
      // الأحد كان يصبح 0 مع weekday % 7 فلا يطابق dayOfWeek = 7 المخزَّن.
      expect(DateHelpers.scheduleDayOf(DateTime(2026, 3, 8)), DateTime.sunday);
      expect(DateHelpers.scheduleDayOf(DateTime(2026, 3, 7)), DateTime.saturday);
      expect(DateHelpers.scheduleDayOf(DateTime(2026, 3, 9)), DateTime.monday);
    });

    test('arabicDayNameOfScheduleDay يعكس نفس التحويل', () {
      expect(DateHelpers.arabicDayNameOfScheduleDay(DateTime.saturday), 'السبت');
      expect(DateHelpers.arabicDayNameOfScheduleDay(DateTime.sunday), 'الأحد');
      expect(DateHelpers.arabicDayNameOfScheduleDay(DateTime.friday), 'الجمعة');
    });

    test('startOfWeek يرجع للسبت السابق', () {
      expect(DateHelpers.startOfWeek(DateTime(2026, 3, 11)),
          DateTime(2026, 3, 7));
      expect(DateHelpers.startOfWeek(DateTime(2026, 3, 7)),
          DateTime(2026, 3, 7));
    });

    test('endOfWeek يقع على الجمعة التالية', () {
      final end = DateHelpers.endOfWeek(DateTime(2026, 3, 11));
      expect(end.day, 13);
      expect(DateHelpers.getArabicDayName(end), 'الجمعة');
    });
  });

  group('حدود الشهر', () {
    test('endOfMonth يشمل آخر لحظة من آخر يوم', () {
      final end = DateHelpers.endOfMonth(DateTime(2026, 2, 10));
      expect(end.day, 28);
      expect(end.hour, 23);
      expect(end.minute, 59);
    });

    test('يتعامل مع السنة الكبيسة', () {
      expect(DateHelpers.endOfMonth(DateTime(2028, 2, 1)).day, 29);
    });
  });

  group('تنسيق المدد', () {
    test('formatDurationCompact يعرض ساعات ودقائق', () {
      expect(DateHelpers.formatDurationCompact(225), '3س 45د');
      expect(DateHelpers.formatDurationCompact(0), '0س 0د');
      expect(DateHelpers.formatDurationCompact(-90), '-1س 30د');
    });

    test('formatShortDate يستخدم أسماء الشهور العربية', () {
      expect(DateHelpers.formatShortDate(DateTime(2026, 3, 12)), '12 مارس 2026');
    });
  });
}
