import '../entities/calendar_day_entity.dart';
import '../entities/profile_entity.dart';

/// يدمج تقويم الجهة مع جدولها ليخرج بإعداد اليوم الفعلي.
///
/// الجدول يقول ما يتكرّر كل أسبوع، والتقويم يقول ما يخالفه في تاريخ بعينه.
/// الحساب لا يعرف إلا الناتج، فلا يتفرّع على نوع اليوم في كل موضع.
class EffectiveDayResolver {
  const EffectiveDayResolver._();

  /// الإدخال الحاكم ليوم بعينه في جهة بعينها.
  ///
  /// الأخصّ يغلب: إدخال الجهة يسبق الإدخال العام، فيمكن أن يكون يومٌ عطلةً
  /// رسمية عند الجميع ودواماً عادياً عند جهة واحدة.
  static CalendarDayEntity? governing(
    List<CalendarDayEntity> entries,
    int companyId,
  ) {
    CalendarDayEntity? general;
    for (final entry in entries) {
      if (entry.companyId == companyId) return entry;
      if (entry.companyId == null) general ??= entry;
    }
    return general;
  }

  /// إعداد اليوم بعد تطبيق التقويم عليه.
  ///
  /// العطلة تُفرِّغ المطلوب ونافذة الوردية معاً: بلا تفريغ النافذة يبقى
  /// اليوم يحسب عجزاً عن ساعات لم تُطلَب أصلاً.
  static WorkDayConfigEntity apply({
    required WorkDayConfigEntity base,
    required CalendarDayEntity? entry,
  }) {
    if (entry == null) return base;

    return switch (entry.kind) {
      CalendarDayKindEntity.publicHoliday ||
      CalendarDayKindEntity.workplaceHoliday =>
        base.copyWith(
          isWorkingDay: false,
          isHoliday: true,
          requiredHours: 0,
          requiredMinutes: 0,
          clearWindow: true,
        ),

      // دوام استثنائي في يوم راحة: يُفتح اليوم بساعاته المجدولة إن كانت
      // معلومة، وإلا فبثماني ساعات — وهي القيمة التي يفترضها الجدول أصلاً
      // ليوم بلا إعداد.
      CalendarDayKindEntity.specialWorkday => base.copyWith(
          isWorkingDay: true,
          isHoliday: false,
          requiredHours: base.requiredMinutesTotal > 0 ? base.requiredHours : 8,
          requiredMinutes:
              base.requiredMinutesTotal > 0 ? base.requiredMinutes : 0,
        ),
    };
  }
}
