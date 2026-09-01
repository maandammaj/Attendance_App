import '../../core/utils/date_helpers.dart';

/// المدى الزمني الذي يُبنى عليه التقرير.
class ReportPeriod {
  const ReportPeriod({
    required this.from,
    required this.to,
    required this.label,
    required this.granularity,
  });

  final DateTime from;
  final DateTime to;
  final String label;
  final ReportGranularity granularity;

  factory ReportPeriod.month(DateTime anchor) => ReportPeriod(
        from: DateHelpers.startOfMonth(anchor),
        to: DateHelpers.endOfMonth(anchor),
        label:
            '${DateHelpers.arabicMonths[anchor.month - 1]} ${anchor.year}',
        granularity: ReportGranularity.day,
      );

  factory ReportPeriod.week(DateTime anchor) => ReportPeriod(
        from: DateHelpers.startOfWeek(anchor),
        to: DateHelpers.endOfWeek(anchor),
        label:
            'أسبوع ${DateHelpers.formatShortDate(DateHelpers.startOfWeek(anchor))}',
        granularity: ReportGranularity.day,
      );

  factory ReportPeriod.year(DateTime anchor) => ReportPeriod(
        from: DateHelpers.startOfYear(anchor),
        to: DateHelpers.endOfYear(anchor),
        label: 'سنة ${anchor.year}',
        granularity: ReportGranularity.month,
      );

  factory ReportPeriod.custom(DateTime from, DateTime to) => ReportPeriod(
        from: DateHelpers.startOfDay(from),
        to: DateHelpers.endOfDay(to),
        label:
            '${DateHelpers.formatShortDate(from)} — ${DateHelpers.formatShortDate(to)}',
        granularity: to.difference(from).inDays > 62
            ? ReportGranularity.month
            : ReportGranularity.day,
      );
}

enum ReportGranularity { day, month }

/// نقطة على محور زمني — تستخدمها الرسوم الخطية والأعمدة على السواء.
class TimeSeriesPoint {
  const TimeSeriesPoint({
    required this.date,
    required this.label,
    required this.value,
    this.secondaryValue = 0,
  });

  final DateTime date;
  final String label;
  final double value;

  /// قيمة ثانية على نفس النقطة (إضافي مقابل رسمي، مصروف مقابل دخل).
  final double secondaryValue;
}

class CategoryBreakdownItem {
  const CategoryBreakdownItem({
    required this.name,
    required this.amount,
    required this.share,
    required this.transactionCount,
  });

  final String name;
  final double amount;

  /// نصيب الفئة من الإجمالي (0.0 – 1.0).
  final double share;
  final int transactionCount;
}

/// يوم واحد في خريطة التقويم الحرارية.
class CalendarDayCell {
  const CalendarDayCell({
    required this.date,
    required this.workedMinutes,
    required this.requiredMinutes,
    required this.overtimeMinutes,
    required this.deficitMinutes,
    required this.status,
  });

  final DateTime date;
  final int workedMinutes;
  final int requiredMinutes;
  final int overtimeMinutes;
  final int deficitMinutes;
  final DayStatus status;

  /// نسبة الإنجاز مقابل المطلوب، مقصوصة عند 1.5 حتى لا يبتلع يومٌ واحد التدرّج.
  double get completion {
    if (requiredMinutes <= 0) return workedMinutes > 0 ? 1 : 0;
    return (workedMinutes / requiredMinutes).clamp(0.0, 1.5);
  }
}

enum DayStatus { worked, overtime, deficit, absent, dayOff, future }

class AttendanceAnalytics {
  const AttendanceAnalytics({
    required this.dailySeries,
    required this.calendar,
    required this.averageByWeekday,
    required this.totalWorkedMinutes,
    required this.totalOvertimeMinutes,
    required this.totalDeficitMinutes,
    required this.expectedWorkingDays,
    required this.attendedDays,
    required this.absentDays,
    required this.averageCheckInMinutes,
    required this.averageCheckOutMinutes,
    required this.punctualityRate,
    required this.longestStreak,
  });

  final List<TimeSeriesPoint> dailySeries;
  final List<CalendarDayCell> calendar;

  /// متوسط الدقائق المشتغلة لكل يوم أسبوع (0 = السبت … 6 = الجمعة).
  final List<double> averageByWeekday;

  final int totalWorkedMinutes;
  final int totalOvertimeMinutes;
  final int totalDeficitMinutes;
  final int expectedWorkingDays;
  final int attendedDays;
  final int absentDays;

  /// متوسط وقت الحضور/الانصراف بالدقائق منذ منتصف الليل، أو null بلا سجلات.
  final int? averageCheckInMinutes;
  final int? averageCheckOutMinutes;

  /// نسبة الأيام التي حضر فيها دون عجز.
  final double punctualityRate;

  /// أطول سلسلة أيام عمل متتالية بحضور مسجّل.
  final int longestStreak;

  double get attendanceRate =>
      expectedWorkingDays == 0 ? 0 : attendedDays / expectedWorkingDays;
}

class FinanceAnalytics {
  const FinanceAnalytics({
    required this.series,
    required this.expenseByCategory,
    required this.incomeByCategory,
    required this.totalIncome,
    required this.totalExpense,
    required this.transactionCount,
    required this.largestExpense,
    required this.dailyAverageExpense,
  });

  /// دخل (value) مقابل مصروف (secondaryValue) على المحور الزمني.
  final List<TimeSeriesPoint> series;

  final List<CategoryBreakdownItem> expenseByCategory;
  final List<CategoryBreakdownItem> incomeByCategory;
  final double totalIncome;
  final double totalExpense;
  final int transactionCount;
  final CategoryBreakdownItem? largestExpense;
  final double dailyAverageExpense;

  double get netFlow => totalIncome - totalExpense;
  double get savingsRate => totalIncome <= 0 ? 0 : netFlow / totalIncome;
}

class SalaryBreakdown {
  const SalaryBreakdown({
    required this.baseSalary,
    required this.overtimeValue,
    required this.deficitValue,
    required this.adjustments,
    required this.gross,
    required this.debtPayments,
    required this.expenses,
    required this.net,
    required this.hourlyWage,
    required this.overtimeHourlyRate,
  });

  final double baseSalary;
  final double overtimeValue;
  final double deficitValue;
  final double adjustments;
  final double gross;
  final double debtPayments;
  final double expenses;
  final double net;
  final double hourlyWage;
  final double overtimeHourlyRate;
}

/// التقرير الكامل لفترة واحدة — ما تعرضه شاشة التحليلات وما يُصدَّر PDF/CSV.
class AnalyticsReport {
  const AnalyticsReport({
    required this.period,
    required this.attendance,
    required this.finance,
    required this.salary,
    required this.monthlyComparison,
    required this.currency,
    required this.employeeName,
    required this.jobTitle,
    required this.companyName,
  });

  final ReportPeriod period;
  final AttendanceAnalytics attendance;
  final FinanceAnalytics finance;
  final SalaryBreakdown salary;

  /// آخر 6 فترات لمقارنة الاتجاه — صافي الراتب (value) مقابل المصروف (secondary).
  final List<TimeSeriesPoint> monthlyComparison;

  final String currency;
  final String employeeName;
  final String jobTitle;
  final String? companyName;
}
