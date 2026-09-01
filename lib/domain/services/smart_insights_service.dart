import '../../core/constants/app_constants.dart';
import '../../core/constants/notification_ids.dart';
import '../../core/services/notification_service.dart';
import '../../core/utils/date_helpers.dart';
import '../../core/utils/salary_calculator.dart';
import '../../data/models/notification_model.dart';
import '../entities/attendance_entity.dart';
import '../entities/budget_limit_entity.dart';
import '../entities/profile_entity.dart';
import '../entities/reminder_settings_entity.dart';
import '../entities/transaction_entity.dart';
import '../repositories/budget_limit_repository.dart';
import '../repositories/debt_repository.dart';
import '../repositories/transaction_repository.dart';
import '../usecases/debt/get_debts_summary_usecase.dart';

/// تنبيه محسوب من الحالة الحالية، قبل أن يُعرض.
///
/// الفصل بين التوليد والعرض يجعل نفس القواعد قابلة لإعادة الاستخدام في
/// شاشة "رؤى" داخل التطبيق دون إطلاق إشعار.
class Insight {
  const Insight({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.dedupeKey,
    required this.severity,
    this.payload,
  });

  final int id;
  final String title;
  final String body;
  final NotificationCategory category;
  final String dedupeKey;
  final InsightSeverity severity;
  final String? payload;
}

enum InsightSeverity { info, warning, critical }

/// القواعد التي تُقيَّم عند كل فتح للتطبيق — ما لا يمكن جدولته مسبقاً لأنه
/// يعتمد على بيانات تتغير (رصيد، ساعات مفتوحة، معدل صرف).
///
/// [ReminderScheduler] يغطي النصف الآخر: ما يُعرف وقته مقدماً.
class SmartInsightsService {
  SmartInsightsService({
    required this.transactionRepository,
    required this.budgetLimitRepository,
    required this.debtRepository,
    NotificationService? notifications,
  }) : _notifications = notifications ?? NotificationService();

  final TransactionRepository transactionRepository;
  final BudgetLimitRepository budgetLimitRepository;
  final DebtRepository debtRepository;
  final NotificationService _notifications;

  /// يقيّم كل القواعد ويطلق ما ينطبق منها. يعيد ما أُطلق فعلاً.
  Future<List<Insight>> run({
    required ProfileEntity? profile,
    required ReminderSettingsEntity settings,
    required AttendanceEntity? todayRecord,
  }) async {
    final now = DateTime.now();
    final insights = <Insight>[];

    insights.addAll(_attendanceInsights(
      now: now,
      profile: profile,
      settings: settings,
      todayRecord: todayRecord,
    ));

    final transactions =
        await transactionRepository.getMonthlyTransactions(now.year, now.month);

    if (settings.budgetOverrunEnabled) {
      final statuses = await budgetLimitRepository.getStatus(now.year, now.month);
      insights.addAll(_budgetInsights(statuses, settings, now));
    }

    if (settings.unusualSpendingEnabled) {
      final previous = await transactionRepository.getTransactionsBetween(
        DateHelpers.startOfMonth(DateTime(now.year, now.month - 1)),
        DateHelpers.endOfMonth(DateTime(now.year, now.month - 1)),
      );
      final insight = _unusualSpendingInsight(transactions, previous, now);
      if (insight != null) insights.add(insight);
    }

    if (settings.debtRatioEnabled && profile != null) {
      final summary = await GetDebtsSummaryUseCase(debtRepository)();
      final insight = _debtRatioInsight(summary, profile, settings, now);
      if (insight != null) insights.add(insight);
    }

    if (settings.monthEndForecastEnabled && profile != null) {
      final insight = _forecastInsight(transactions, profile, now);
      if (insight != null) insights.add(insight);
    }

    if (settings.recurringExpenseEnabled) {
      insights.addAll(_recurringExpenseInsights(transactions, now));
    }

    // ساعات الهدوء تكتم غير الحرج فقط؛ نسيان تسجيل الخروج يكلّف مالاً.
    final due = settings.isQuietAt(now)
        ? insights
            .where((i) => i.severity == InsightSeverity.critical)
            .toList()
        : insights;

    for (final insight in due) {
      await _notifications.showNotification(
        id: insight.id,
        title: insight.title,
        body: insight.body,
        category: insight.category,
        payload: insight.payload,
        dedupeKey: insight.dedupeKey,
      );
    }
    return due;
  }

  // ── الدوام ──────────────────────────────────────────────────────

  List<Insight> _attendanceInsights({
    required DateTime now,
    required ProfileEntity? profile,
    required ReminderSettingsEntity settings,
    required AttendanceEntity? todayRecord,
  }) {
    final checkIn = todayRecord?.checkIn;
    if (checkIn == null || todayRecord?.checkOut != null) return const [];

    final insights = <Insight>[];
    final elapsed = now.difference(checkIn);
    final dayKey = DateHelpers.formatShortDate(checkIn);

    if (settings.forgotCheckOutEnabled &&
        elapsed.inHours >= settings.forgotCheckOutAfterHours) {
      insights.add(Insight(
        id: NotificationIds.attendanceLive.idFor(0),
        title: 'هل نسيت تسجيل الخروج؟',
        body:
            'سجل الدخول مفتوح منذ ${DateHelpers.formatDuration(elapsed.inMinutes)}. أغلقه حتى تُحتسب ساعاتك ومستحقاتك بدقة.',
        category: NotificationCategory.attendance,
        dedupeKey: 'forgot_checkout:$dayKey',
        severity: InsightSeverity.critical,
        payload: 'attendance',
      ));
    }

    final requiredMinutes =
        (todayRecord!.requiredHours * 60) + todayRecord.requiredMinutes;
    if (settings.requiredHoursDoneEnabled &&
        requiredMinutes > 0 &&
        elapsed.inMinutes >= requiredMinutes) {
      final overtimeMinutes = elapsed.inMinutes - requiredMinutes;
      final extra = profile == null
          ? ''
          : ' كسبت ${_money(SalaryCalculator(profile).calculateOvertimeValue(overtimeMinutes ~/ 60, overtimeMinutes % 60), profile)} إضافي حتى الآن.';
      insights.add(Insight(
        id: NotificationIds.attendanceLive.idFor(1),
        title: 'أكملت ساعاتك المطلوبة',
        body:
            'أنجزت ${DateHelpers.formatDurationCompact(requiredMinutes)} المطلوبة، وكل دقيقة بعدها تُحتسب إضافياً.$extra',
        category: NotificationCategory.attendance,
        dedupeKey: 'required_done:$dayKey',
        severity: InsightSeverity.info,
        payload: 'attendance',
      ));
    }

    return insights;
  }

  // ── الميزانية ───────────────────────────────────────────────────

  List<Insight> _budgetInsights(
    List<BudgetStatusEntity> statuses,
    ReminderSettingsEntity settings,
    DateTime now,
  ) {
    final monthKey = '${now.year}-${now.month}';
    final insights = <Insight>[];

    for (final status in statuses) {
      if (status.isOverrun) {
        insights.add(Insight(
          id: NotificationIds.finance.idFor(status.categoryName.hashCode),
          title: 'تجاوزت ميزانية ${status.categoryName}',
          body:
              'صرفت ${status.spent.toStringAsFixed(0)} من حدّ ${status.limit.toStringAsFixed(0)} — بزيادة ${(status.spent - status.limit).toStringAsFixed(0)}.',
          category: NotificationCategory.finance,
          dedupeKey: 'budget_over:${status.categoryName}:$monthKey',
          severity: InsightSeverity.warning,
          payload: 'budget',
        ));
      } else if (status.ratio >= settings.budgetWarnThreshold) {
        insights.add(Insight(
          id: NotificationIds.finance.idFor(status.categoryName.hashCode + 1),
          title: 'اقتربت من حد ${status.categoryName}',
          body:
              'استهلكت ${(status.ratio * 100).toStringAsFixed(0)}% من الميزانية، والمتبقي ${status.remaining.toStringAsFixed(0)} فقط.',
          category: NotificationCategory.finance,
          dedupeKey: 'budget_warn:${status.categoryName}:$monthKey',
          severity: InsightSeverity.info,
          payload: 'budget',
        ));
      }
    }
    return insights;
  }

  /// يقارن معدل الصرف اليومي بنفس الفترة من الشهر الماضي.
  ///
  /// المقارنة بمعدل يومي لا بإجمالي، لأن الشهر الحالي غالباً ناقص.
  Insight? _unusualSpendingInsight(
    List<TransactionEntity> current,
    List<TransactionEntity> previous,
    DateTime now,
  ) {
    final currentSpent = _sumExpenses(current);
    if (currentSpent <= 0 || now.day < 5) return null;

    final previousSameWindow = previous.where((t) => t.date.day <= now.day);
    final previousSpent = _sumExpenses(previousSameWindow);
    if (previousSpent <= 0) return null;

    final growth = (currentSpent - previousSpent) / previousSpent;
    if (growth < 0.3) return null;

    return Insight(
      id: NotificationIds.finance.idFor(90),
      title: 'معدل صرفك أعلى من المعتاد',
      body:
          'صرفت ${currentSpent.toStringAsFixed(0)} حتى يوم ${now.day}، مقابل ${previousSpent.toStringAsFixed(0)} في نفس الفترة الشهر الماضي — بزيادة ${(growth * 100).toStringAsFixed(0)}%.',
      category: NotificationCategory.finance,
      dedupeKey: 'unusual_spending:${now.year}-${now.month}-${now.day ~/ 7}',
      severity: InsightSeverity.warning,
      payload: 'analytics',
    );
  }

  Insight? _debtRatioInsight(
    DebtSummary summary,
    ProfileEntity profile,
    ReminderSettingsEntity settings,
    DateTime now,
  ) {
    if (profile.baseMonthlySalary <= 0) return null;
    final ratio = summary.remainingOwe / profile.baseMonthlySalary;
    if (ratio < settings.debtRatioThreshold) return null;

    return Insight(
      id: NotificationIds.finance.idFor(91),
      title: 'نسبة الدين إلى الراتب مرتفعة',
      body:
          'ما عليك ${_money(summary.remainingOwe, profile)} أي ${(ratio * 100).toStringAsFixed(0)}% من راتبك الشهري. راجع خطة السداد.',
      category: NotificationCategory.finance,
      dedupeKey: 'debt_ratio:${now.year}-${now.month}',
      severity: InsightSeverity.warning,
      payload: 'debts',
    );
  }

  /// يستقرئ مصروفات ما تبقى من الشهر بمعدل الصرف اليومي حتى الآن.
  Insight? _forecastInsight(
    List<TransactionEntity> transactions,
    ProfileEntity profile,
    DateTime now,
  ) {
    if (now.day < 7) return null;

    final spent = _sumExpenses(transactions);
    if (spent <= 0) return null;

    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final projected = (spent / now.day) * daysInMonth;
    final income = profile.baseMonthlySalary +
        _sumIncome(transactions);
    if (projected <= income) return null;

    return Insight(
      id: NotificationIds.finance.idFor(92),
      title: 'توقّع عجز في نهاية الشهر',
      body:
          'بمعدل صرفك الحالي ستنفق ${_money(projected, profile)} مقابل دخل ${_money(income, profile)} — بعجز متوقع ${_money(projected - income, profile)}.',
      category: NotificationCategory.finance,
      dedupeKey: 'forecast:${now.year}-${now.month}-${now.day ~/ 7}',
      severity: InsightSeverity.warning,
      payload: 'analytics',
    );
  }

  /// مصروف متكرر حان يومه ولم يُسجَّل هذا الشهر.
  List<Insight> _recurringExpenseInsights(
    List<TransactionEntity> transactions,
    DateTime now,
  ) {
    final recurring = transactions.where((t) => t.isRecurring).toList();
    if (recurring.isEmpty) return const [];

    final byCategory = <String, TransactionEntity>{};
    for (final transaction in recurring) {
      byCategory.putIfAbsent(transaction.categoryName, () => transaction);
    }

    final insights = <Insight>[];
    for (final entry in byCategory.entries) {
      final day = entry.value.recurringDay;
      if (day == null || now.day < day) continue;

      final loggedThisMonth = transactions.any((t) =>
          t.categoryName == entry.key &&
          !t.isRecurring &&
          t.date.month == now.month &&
          t.date.year == now.year);
      if (loggedThisMonth) continue;

      insights.add(Insight(
        id: NotificationIds.recurringExpense.idFor(entry.key.hashCode),
        title: 'مصروف متكرر لم يُسجَّل',
        body:
            '"${entry.key}" يُستحق يوم $day من كل شهر ولم تسجّله بعد لهذا الشهر.',
        category: NotificationCategory.finance,
        dedupeKey: 'recurring:${entry.key}:${now.year}-${now.month}',
        severity: InsightSeverity.info,
        payload: 'budget',
      ));
    }
    return insights;
  }

  static double _sumExpenses(Iterable<TransactionEntity> transactions) =>
      transactions
          .where((t) => t.type == TransactionTypeEntity.expense)
          .fold(0.0, (sum, t) => sum + t.amount);

  static double _sumIncome(Iterable<TransactionEntity> transactions) =>
      transactions
          .where((t) => t.type == TransactionTypeEntity.income)
          .fold(0.0, (sum, t) => sum + t.amount);

  static String _money(double value, ProfileEntity profile) =>
      '${value.toStringAsFixed(0)} ${profile.currency ?? AppConstants.defaultCurrency}';
}
