import '../constants/app_constants.dart';

class DateHelpers {
  DateHelpers._();

  /// ترقيم أيام الأسبوع المخزَّن في `WorkDayConfig.dayOfWeek` هو ترقيم
  /// `DateTime.weekday` نفسه: الاثنين = 1 … الأحد = 7.
  ///
  /// هذا ما تكتبه شاشة الملف الشخصي وما يفترضه `_resolveDayType`. لا تستخدم
  /// `weekday % 7` للبحث عن إعداد يوم: الأحد يصبح 0 فلا يطابق أي إعداد.
  static int scheduleDayOf(DateTime date) => date.weekday;

  /// موقع اليوم في `AppConstants.arabicDays` التي تبدأ بالسبت.
  ///
  /// السبت = 0 … الجمعة = 6، بينما `DateTime.weekday` يبدأ بالاثنين = 1،
  /// لذلك الإزاحة `+ 1` قبل باقي القسمة.
  static int arabicDayIndex(DateTime date) => (date.weekday + 1) % 7;

  /// نفس التحويل انطلاقاً من قيمة `dayOfWeek` مخزَّنة (1 = الاثنين … 7 = الأحد).
  static int arabicDayIndexOfScheduleDay(int scheduleDay) =>
      (scheduleDay + 1) % 7;

  static String getArabicDayName(DateTime date) {
    return AppConstants.arabicDays[arabicDayIndex(date)];
  }

  static String arabicDayNameOfScheduleDay(int scheduleDay) =>
      AppConstants.arabicDays[arabicDayIndexOfScheduleDay(scheduleDay)];

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59);
  }

  static int minutesBetween(DateTime from, DateTime to) {
    return to.difference(from).inMinutes;
  }

  static String formatDuration(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours > 0 && minutes > 0) {
      return '$hours ساعة و $minutes دقيقة';
    } else if (hours > 0) {
      return '$hours ساعة';
    } else {
      return '$minutes دقيقة';
    }
  }

  /// "12 مارس 2026" — للاستخدام في نصوص التنبيهات ورؤوس التقارير.
  static String formatShortDate(DateTime date) {
    return '${date.day} ${arabicMonths[date.month - 1]} ${date.year}';
  }

  static const List<String> arabicMonths = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
  ];

  /// بداية الأسبوع: السبت هو أول أيام الأسبوع.
  static DateTime startOfWeek(DateTime date) {
    return startOfDay(date.subtract(Duration(days: arabicDayIndex(date))));
  }

  static DateTime endOfWeek(DateTime date) =>
      endOfDay(startOfWeek(date).add(const Duration(days: 6)));

  static DateTime startOfYear(DateTime date) => DateTime(date.year, 1, 1);

  static DateTime endOfYear(DateTime date) =>
      DateTime(date.year, 12, 31, 23, 59, 59);

  /// "3س 45د" — تنسيق مضغوط للجداول والرسوم.
  static String formatDurationCompact(int totalMinutes) {
    final sign = totalMinutes < 0 ? '-' : '';
    final abs = totalMinutes.abs();
    return '$sign${abs ~/ 60}س ${abs % 60}د';
  }

  static String formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}