class ReminderSettingsEntity {
  final bool shiftStartEnabled;
  final int shiftStartLeadMinutes;
  final bool shiftEndEnabled;
  final int shiftEndLeadMinutes;
  final bool requiredHoursDoneEnabled;
  final bool forgotCheckOutEnabled;
  final int forgotCheckOutAfterHours;
  final bool missedCheckInEnabled;
  final int missedCheckInAfterMinutes;

  final bool debtDueEnabled;
  final List<int> debtDueLeadDays;
  final bool debtOverdueEnabled;

  final bool budgetOverrunEnabled;
  final double budgetWarnThreshold;
  final bool unusualSpendingEnabled;
  final bool debtRatioEnabled;
  final double debtRatioThreshold;
  final bool monthEndForecastEnabled;

  final bool dailySummaryEnabled;
  final String dailySummaryTime;
  final bool weeklySummaryEnabled;
  final int weeklySummaryDayOfWeek;
  final String weeklySummaryTime;
  final bool monthlySummaryEnabled;
  final int monthlySummaryDayOfMonth;
  final String monthlySummaryTime;
  final bool recurringExpenseEnabled;

  final bool quietHoursEnabled;
  final String quietHoursStart;
  final String quietHoursEnd;

  const ReminderSettingsEntity({
    this.shiftStartEnabled = true,
    this.shiftStartLeadMinutes = 30,
    this.shiftEndEnabled = true,
    this.shiftEndLeadMinutes = 15,
    this.requiredHoursDoneEnabled = true,
    this.forgotCheckOutEnabled = true,
    this.forgotCheckOutAfterHours = 12,
    this.missedCheckInEnabled = true,
    this.missedCheckInAfterMinutes = 45,
    this.debtDueEnabled = true,
    this.debtDueLeadDays = const [7, 3, 1],
    this.debtOverdueEnabled = true,
    this.budgetOverrunEnabled = true,
    this.budgetWarnThreshold = 0.8,
    this.unusualSpendingEnabled = true,
    this.debtRatioEnabled = true,
    this.debtRatioThreshold = 0.5,
    this.monthEndForecastEnabled = true,
    this.dailySummaryEnabled = true,
    this.dailySummaryTime = '21:00',
    this.weeklySummaryEnabled = true,
    this.weeklySummaryDayOfWeek = DateTime.wednesday,
    this.weeklySummaryTime = '20:00',
    this.monthlySummaryEnabled = true,
    this.monthlySummaryDayOfMonth = 28,
    this.monthlySummaryTime = '19:00',
    this.recurringExpenseEnabled = true,
    this.quietHoursEnabled = false,
    this.quietHoursStart = '23:00',
    this.quietHoursEnd = '07:00',
  });

  /// هل الوقت [now] داخل نافذة الهدوء؟ تدعم النوافذ العابرة لمنتصف الليل.
  bool isQuietAt(DateTime now) {
    if (!quietHoursEnabled) return false;
    final start = _minutesOf(quietHoursStart);
    final end = _minutesOf(quietHoursEnd);
    final current = (now.hour * 60) + now.minute;
    if (start == end) return false;
    if (start < end) return current >= start && current < end;
    return current >= start || current < end;
  }

  static int _minutesOf(String hhmm) {
    final parts = hhmm.split(':');
    return (int.parse(parts[0]) * 60) + int.parse(parts[1]);
  }

  ReminderSettingsEntity copyWith({
    bool? shiftStartEnabled,
    int? shiftStartLeadMinutes,
    bool? shiftEndEnabled,
    int? shiftEndLeadMinutes,
    bool? requiredHoursDoneEnabled,
    bool? forgotCheckOutEnabled,
    int? forgotCheckOutAfterHours,
    bool? missedCheckInEnabled,
    int? missedCheckInAfterMinutes,
    bool? debtDueEnabled,
    List<int>? debtDueLeadDays,
    bool? debtOverdueEnabled,
    bool? budgetOverrunEnabled,
    double? budgetWarnThreshold,
    bool? unusualSpendingEnabled,
    bool? debtRatioEnabled,
    double? debtRatioThreshold,
    bool? monthEndForecastEnabled,
    bool? dailySummaryEnabled,
    String? dailySummaryTime,
    bool? weeklySummaryEnabled,
    int? weeklySummaryDayOfWeek,
    String? weeklySummaryTime,
    bool? monthlySummaryEnabled,
    int? monthlySummaryDayOfMonth,
    String? monthlySummaryTime,
    bool? recurringExpenseEnabled,
    bool? quietHoursEnabled,
    String? quietHoursStart,
    String? quietHoursEnd,
  }) {
    return ReminderSettingsEntity(
      shiftStartEnabled: shiftStartEnabled ?? this.shiftStartEnabled,
      shiftStartLeadMinutes: shiftStartLeadMinutes ?? this.shiftStartLeadMinutes,
      shiftEndEnabled: shiftEndEnabled ?? this.shiftEndEnabled,
      shiftEndLeadMinutes: shiftEndLeadMinutes ?? this.shiftEndLeadMinutes,
      requiredHoursDoneEnabled:
          requiredHoursDoneEnabled ?? this.requiredHoursDoneEnabled,
      forgotCheckOutEnabled:
          forgotCheckOutEnabled ?? this.forgotCheckOutEnabled,
      forgotCheckOutAfterHours:
          forgotCheckOutAfterHours ?? this.forgotCheckOutAfterHours,
      missedCheckInEnabled: missedCheckInEnabled ?? this.missedCheckInEnabled,
      missedCheckInAfterMinutes:
          missedCheckInAfterMinutes ?? this.missedCheckInAfterMinutes,
      debtDueEnabled: debtDueEnabled ?? this.debtDueEnabled,
      debtDueLeadDays: debtDueLeadDays ?? this.debtDueLeadDays,
      debtOverdueEnabled: debtOverdueEnabled ?? this.debtOverdueEnabled,
      budgetOverrunEnabled: budgetOverrunEnabled ?? this.budgetOverrunEnabled,
      budgetWarnThreshold: budgetWarnThreshold ?? this.budgetWarnThreshold,
      unusualSpendingEnabled:
          unusualSpendingEnabled ?? this.unusualSpendingEnabled,
      debtRatioEnabled: debtRatioEnabled ?? this.debtRatioEnabled,
      debtRatioThreshold: debtRatioThreshold ?? this.debtRatioThreshold,
      monthEndForecastEnabled:
          monthEndForecastEnabled ?? this.monthEndForecastEnabled,
      dailySummaryEnabled: dailySummaryEnabled ?? this.dailySummaryEnabled,
      dailySummaryTime: dailySummaryTime ?? this.dailySummaryTime,
      weeklySummaryEnabled: weeklySummaryEnabled ?? this.weeklySummaryEnabled,
      weeklySummaryDayOfWeek:
          weeklySummaryDayOfWeek ?? this.weeklySummaryDayOfWeek,
      weeklySummaryTime: weeklySummaryTime ?? this.weeklySummaryTime,
      monthlySummaryEnabled:
          monthlySummaryEnabled ?? this.monthlySummaryEnabled,
      monthlySummaryDayOfMonth:
          monthlySummaryDayOfMonth ?? this.monthlySummaryDayOfMonth,
      monthlySummaryTime: monthlySummaryTime ?? this.monthlySummaryTime,
      recurringExpenseEnabled:
          recurringExpenseEnabled ?? this.recurringExpenseEnabled,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
    );
  }
}
