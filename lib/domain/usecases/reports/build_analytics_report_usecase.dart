import '../../../core/constants/app_constants.dart';
import '../../../core/utils/date_helpers.dart';
import '../../../core/utils/salary_calculator.dart';
import '../../entities/analytics_report_entity.dart';
import '../../entities/attendance_entity.dart';
import '../../entities/profile_entity.dart';
import '../../entities/transaction_entity.dart';
import '../../repositories/attendance_repository.dart';
import '../../repositories/debt_repository.dart';
import '../../repositories/transaction_repository.dart';
import '../debt/get_debts_summary_usecase.dart';

/// يجمع سجلات الحضور والمعاملات لفترة واحدة في [AnalyticsReport].
///
/// كل الحسابات هنا مشتقة من البيانات المخزنة، ما عدا قيم الإضافي والعجز
/// التي تُقرأ كما كُتبت وقت التسجيل — تغيير الراتب لا يعيد حساب الماضي.
class BuildAnalyticsReportUseCase {
  BuildAnalyticsReportUseCase({
    required this.attendanceRepository,
    required this.transactionRepository,
    required this.debtRepository,
  });

  final AttendanceRepository attendanceRepository;
  final TransactionRepository transactionRepository;
  final DebtRepository debtRepository;

  Future<AnalyticsReport> call({
    required ReportPeriod period,
    required ProfileEntity profile,
  }) async {
    final records = await attendanceRepository.getRecordsBetween(
      period.from,
      period.to,
    );
    final transactions = await transactionRepository.getTransactionsBetween(
      period.from,
      period.to,
    );

    final attendance = _buildAttendance(period, records, profile);
    final finance = _buildFinance(period, transactions);

    final debtSummary = await GetDebtsSummaryUseCase(debtRepository)();
    final salary = _buildSalary(
      profile: profile,
      attendance: attendance,
      records: records,
      expenses: finance.totalExpense,
      debtPayments: debtSummary.totalPaidOwe,
    );

    return AnalyticsReport(
      period: period,
      attendance: attendance,
      finance: finance,
      salary: salary,
      monthlyComparison: await _buildComparison(period, profile),
      currency: profile.currency ?? AppConstants.defaultCurrency,
      employeeName: profile.fullName,
      jobTitle: profile.jobTitle,
      companyName: profile.companyName,
    );
  }

  // ── الحضور ──────────────────────────────────────────────────────

  AttendanceAnalytics _buildAttendance(
    ReportPeriod period,
    List<AttendanceEntity> records,
    ProfileEntity profile,
  ) {
    final byDate = <DateTime, AttendanceEntity>{
      for (final record in records) DateHelpers.startOfDay(record.date): record,
    };

    final now = DateTime.now();
    final calendar = <CalendarDayCell>[];
    final series = <TimeSeriesPoint>[];
    final weekdayTotals = List<double>.filled(7, 0);
    final weekdayCounts = List<int>.filled(7, 0);

    int totalWorked = 0;
    int totalOvertime = 0;
    int totalDeficit = 0;
    int expectedDays = 0;
    int attendedDays = 0;
    int punctualDays = 0;
    int streak = 0;
    int longestStreak = 0;
    final checkInMinutes = <int>[];
    final checkOutMinutes = <int>[];

    for (var day = DateHelpers.startOfDay(period.from);
        !day.isAfter(period.to);
        day = day.add(const Duration(days: 1))) {
      final dayOfWeek = DateHelpers.scheduleDayOf(day);
      final config = _configFor(profile, dayOfWeek);
      final record = byDate[day];
      final isWorkDay = config.isWorkingDay && !config.isHoliday;
      final requiredMinutes =
          isWorkDay ? (config.requiredHours * 60) + config.requiredMinutes : 0;

      final workedMinutes = record == null
          ? 0
          : (record.workedHours * 60) + record.workedMinutes;
      final overtimeMinutes = record == null
          ? 0
          : (record.overtimeHours * 60) + record.overtimeMinutes;
      final deficitMinutes = record == null
          ? 0
          : (record.deficitHours * 60) + record.deficitMinutes;

      totalWorked += workedMinutes;
      totalOvertime += overtimeMinutes;
      totalDeficit += deficitMinutes;

      final isFuture = day.isAfter(now);
      if (isWorkDay && !isFuture) {
        expectedDays++;
        if (record?.checkIn != null) {
          attendedDays++;
          streak++;
          longestStreak = streak > longestStreak ? streak : longestStreak;
          if (deficitMinutes == 0) punctualDays++;
        } else {
          streak = 0;
        }
      }

      if (record?.checkIn != null) {
        checkInMinutes
            .add((record!.checkIn!.hour * 60) + record.checkIn!.minute);
      }
      if (record?.checkOut != null) {
        checkOutMinutes
            .add((record!.checkOut!.hour * 60) + record.checkOut!.minute);
      }

      if (isWorkDay && record != null) {
        // الرادار يعرض بترتيب arabicDays (السبت أولاً)، لا بترقيم التخزين.
        final displayIndex = DateHelpers.arabicDayIndex(day);
        weekdayTotals[displayIndex] += workedMinutes + overtimeMinutes;
        weekdayCounts[displayIndex]++;
      }

      calendar.add(CalendarDayCell(
        date: day,
        workedMinutes: workedMinutes,
        requiredMinutes: requiredMinutes,
        overtimeMinutes: overtimeMinutes,
        deficitMinutes: deficitMinutes,
        status: _statusFor(
          isFuture: isFuture,
          isWorkDay: isWorkDay,
          hasRecord: record?.checkIn != null,
          overtimeMinutes: overtimeMinutes,
          deficitMinutes: deficitMinutes,
        ),
      ));

      if (period.granularity == ReportGranularity.day) {
        series.add(TimeSeriesPoint(
          date: day,
          label: '${day.day}',
          value: workedMinutes / 60,
          secondaryValue: overtimeMinutes / 60,
        ));
      }
    }

    if (period.granularity == ReportGranularity.month) {
      series.addAll(_monthlyBuckets(calendar));
    }

    return AttendanceAnalytics(
      dailySeries: series,
      calendar: calendar,
      averageByWeekday: [
        for (int i = 0; i < 7; i++)
          weekdayCounts[i] == 0 ? 0 : weekdayTotals[i] / weekdayCounts[i] / 60,
      ],
      totalWorkedMinutes: totalWorked,
      totalOvertimeMinutes: totalOvertime,
      totalDeficitMinutes: totalDeficit,
      expectedWorkingDays: expectedDays,
      attendedDays: attendedDays,
      absentDays: expectedDays - attendedDays,
      averageCheckInMinutes: _average(checkInMinutes),
      averageCheckOutMinutes: _average(checkOutMinutes),
      punctualityRate: attendedDays == 0 ? 0 : punctualDays / attendedDays,
      longestStreak: longestStreak,
    );
  }

  List<TimeSeriesPoint> _monthlyBuckets(List<CalendarDayCell> calendar) {
    final worked = <int, int>{};
    final overtime = <int, int>{};
    for (final cell in calendar) {
      final key = (cell.date.year * 100) + cell.date.month;
      worked.update(key, (v) => v + cell.workedMinutes,
          ifAbsent: () => cell.workedMinutes);
      overtime.update(key, (v) => v + cell.overtimeMinutes,
          ifAbsent: () => cell.overtimeMinutes);
    }
    final keys = worked.keys.toList()..sort();
    return [
      for (final key in keys)
        TimeSeriesPoint(
          date: DateTime(key ~/ 100, key % 100),
          label: DateHelpers.arabicMonths[(key % 100) - 1],
          value: worked[key]! / 60,
          secondaryValue: overtime[key]! / 60,
        ),
    ];
  }

  static DayStatus _statusFor({
    required bool isFuture,
    required bool isWorkDay,
    required bool hasRecord,
    required int overtimeMinutes,
    required int deficitMinutes,
  }) {
    if (isFuture) return DayStatus.future;
    if (!isWorkDay) return hasRecord ? DayStatus.overtime : DayStatus.dayOff;
    if (!hasRecord) return DayStatus.absent;
    if (deficitMinutes > 0) return DayStatus.deficit;
    if (overtimeMinutes > 0) return DayStatus.overtime;
    return DayStatus.worked;
  }

  static WorkDayConfigEntity _configFor(ProfileEntity profile, int dayOfWeek) {
    return profile.workSchedule.firstWhere(
      (day) => day.dayOfWeek == dayOfWeek,
      orElse: () => WorkDayConfigEntity(
        dayOfWeek: dayOfWeek,
        isWorkingDay: false,
        requiredHours: 0,
        requiredMinutes: 0,
        isHoliday: true,
      ),
    );
  }

  static int? _average(List<int> values) => values.isEmpty
      ? null
      : values.reduce((a, b) => a + b) ~/ values.length;

  // ── المالية ─────────────────────────────────────────────────────

  FinanceAnalytics _buildFinance(
    ReportPeriod period,
    List<TransactionEntity> transactions,
  ) {
    final expenses = transactions
        .where((t) => t.type == TransactionTypeEntity.expense)
        .toList();
    final incomes = transactions
        .where((t) => t.type == TransactionTypeEntity.income)
        .toList();

    final totalExpense = expenses.fold(0.0, (sum, t) => sum + t.amount);
    final totalIncome = incomes.fold(0.0, (sum, t) => sum + t.amount);

    final expenseByCategory = _breakdown(expenses, totalExpense);
    final days = period.to.difference(period.from).inDays + 1;

    final buckets = <DateTime, (double income, double expense)>{};
    for (final transaction in transactions) {
      final key = period.granularity == ReportGranularity.month
          ? DateTime(transaction.date.year, transaction.date.month)
          : DateHelpers.startOfDay(transaction.date);
      final current = buckets[key] ?? (0.0, 0.0);
      buckets[key] = transaction.type == TransactionTypeEntity.income
          ? (current.$1 + transaction.amount, current.$2)
          : (current.$1, current.$2 + transaction.amount);
    }
    final keys = buckets.keys.toList()..sort();

    return FinanceAnalytics(
      series: [
        for (final key in keys)
          TimeSeriesPoint(
            date: key,
            label: period.granularity == ReportGranularity.month
                ? DateHelpers.arabicMonths[key.month - 1]
                : '${key.day}',
            value: buckets[key]!.$1,
            secondaryValue: buckets[key]!.$2,
          ),
      ],
      expenseByCategory: expenseByCategory,
      incomeByCategory: _breakdown(incomes, totalIncome),
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      transactionCount: transactions.length,
      largestExpense:
          expenseByCategory.isEmpty ? null : expenseByCategory.first,
      dailyAverageExpense: days == 0 ? 0 : totalExpense / days,
    );
  }

  static List<CategoryBreakdownItem> _breakdown(
    List<TransactionEntity> transactions,
    double total,
  ) {
    final amounts = <String, double>{};
    final counts = <String, int>{};
    for (final transaction in transactions) {
      amounts.update(transaction.categoryName, (v) => v + transaction.amount,
          ifAbsent: () => transaction.amount);
      counts.update(transaction.categoryName, (v) => v + 1, ifAbsent: () => 1);
    }
    final items = [
      for (final entry in amounts.entries)
        CategoryBreakdownItem(
          name: entry.key,
          amount: entry.value,
          share: total <= 0 ? 0 : entry.value / total,
          transactionCount: counts[entry.key]!,
        ),
    ]..sort((a, b) => b.amount.compareTo(a.amount));
    return items;
  }

  // ── الراتب ──────────────────────────────────────────────────────

  SalaryBreakdown _buildSalary({
    required ProfileEntity profile,
    required AttendanceAnalytics attendance,
    required List<AttendanceEntity> records,
    required double expenses,
    required double debtPayments,
  }) {
    final calculator = SalaryCalculator(profile);
    final overtimeValue =
        records.fold(0.0, (sum, record) => sum + record.overtimeValue);
    final deficitValue =
        records.fold(0.0, (sum, record) => sum + record.deficitValue);

    // الغياب غير المسجَّل لا يملك سجلاً، فقيمته تُحسب من دقائق العجز الكلية
    // ناقص ما هو مخزن في السجلات.
    final recordedDeficitMinutes = records.fold(
        0, (sum, r) => sum + (r.deficitHours * 60) + r.deficitMinutes);
    final absenceMinutes = attendance.absentDays == 0
        ? 0
        : attendance.totalDeficitMinutes - recordedDeficitMinutes;
    final absenceValue = absenceMinutes <= 0
        ? 0.0
        : calculator.calculateDeficitValue(
            absenceMinutes ~/ 60, absenceMinutes % 60);

    final monthly = calculator.calculateMonthly(
      totalOvertimeValue: overtimeValue,
      totalDeficitValue: deficitValue + absenceValue,
      totalDebtPayments: debtPayments,
      totalTransactionsExpenses: expenses,
    );

    return SalaryBreakdown(
      baseSalary: profile.baseMonthlySalary,
      overtimeValue: overtimeValue,
      deficitValue: deficitValue + absenceValue,
      adjustments: monthly.adjustments,
      gross: monthly.gross,
      debtPayments: debtPayments,
      expenses: expenses,
      net: monthly.net,
      hourlyWage: calculator.hourlyWage,
      overtimeHourlyRate: calculator.overtimeHourlyRate,
    );
  }

  // ── المقارنة ────────────────────────────────────────────────────

  /// صافي الراتب مقابل المصروف لآخر ست فترات منتهية عند [period].
  Future<List<TimeSeriesPoint>> _buildComparison(
    ReportPeriod period,
    ProfileEntity profile,
  ) async {
    final calculator = SalaryCalculator(profile);
    final points = <TimeSeriesPoint>[];

    for (int offset = 5; offset >= 0; offset--) {
      final anchor = DateTime(period.to.year, period.to.month - offset, 1);
      final from = DateHelpers.startOfMonth(anchor);
      final to = DateHelpers.endOfMonth(anchor);

      final records = await attendanceRepository.getRecordsBetween(from, to);
      final transactions =
          await transactionRepository.getTransactionsBetween(from, to);

      final overtime =
          records.fold(0.0, (sum, record) => sum + record.overtimeValue);
      final deficit =
          records.fold(0.0, (sum, record) => sum + record.deficitValue);
      final expense = transactions
          .where((t) => t.type == TransactionTypeEntity.expense)
          .fold(0.0, (sum, t) => sum + t.amount);

      final monthly = calculator.calculateMonthly(
        totalOvertimeValue: overtime,
        totalDeficitValue: deficit,
        totalDebtPayments: 0,
        totalTransactionsExpenses: expense,
      );

      points.add(TimeSeriesPoint(
        date: anchor,
        label: DateHelpers.arabicMonths[anchor.month - 1],
        value: monthly.gross,
        secondaryValue: expense,
      ));
    }
    return points;
  }
}
