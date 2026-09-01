class AppConstants {
  AppConstants._();

  static const String appName = 'إدارة الدوام والميزانية';
  static const String appVersion = '1.0.0';

  // Currency
  static const String defaultCurrency = 'ر.ي';

  // Biometric messages
  static const String biometricCheckInReason = 'سجل دخولك ببصمة إصبعك';
  static const String biometricCheckOutReason = 'سجل خروجك ببصمة إصبعك';
  static const String biometricAppLockReason = 'افتح التطبيق ببصمة إصبعك';

  // Default work schedule
  static const int defaultRegularDayHours = 8;
  static const int defaultThursdayHours = 4;
  static const int defaultFridayHours = 0;
  static const double defaultOvertimeMultiplier = 1.5;

  // Days mapping
  static const List<String> arabicDays = [
    'السبت',
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
  ];
}