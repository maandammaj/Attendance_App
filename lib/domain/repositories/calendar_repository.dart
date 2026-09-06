import '../entities/calendar_day_entity.dart';

abstract class CalendarRepository {
  /// أيام مُعلَّمة تخصّ الجهة الفعّالة أو تسري على الكل، ضمن مدى.
  Future<List<CalendarDayEntity>> getBetween(DateTime from, DateTime to);

  /// الإدخالات الحاكمة ليوم واحد، الأخصّ أولاً.
  Future<List<CalendarDayEntity>> getForDate(DateTime date);

  /// يعلّم يوماً. تمرير [appliesToAllCompanies] يجعله عاماً.
  Future<void> mark({
    required DateTime date,
    required CalendarDayKindEntity kind,
    String? note,
    bool appliesToAllCompanies = false,
  });

  Future<void> unmark(int id);
}
