extension DateTimeExtension on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);
  DateTime get startOfMonth => DateTime(year, month, 1);
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59);

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  int get dayOfWeekArabic => weekday % 7; // 0=السبت, 6=الجمعة
}