import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'attendance_provider.dart';
import 'debt_provider.dart';
import 'company_provider.dart';
import 'transaction_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/salary_calculator.dart';
import '../../domain/entities/analytics_report_entity.dart';
import '../../domain/entities/transaction_entity.dart';

part 'dashboard_provider.g.dart';

@riverpod
Future<DashboardData> dashboardData(Ref ref) async {
  final now = DateTime.now();
  final companyAsync = ref.watch(activeCompanyProvider);
  final statsAsync = ref.watch(attendanceStatsProvider(year: now.year, month: now.month));
  final debtSummaryAsync = ref.watch(debtSummaryProvider);
  final transactionsAsync = ref.watch(monthlyTransactionsProvider(year: now.year, month: now.month));

  final company = companyAsync.valueOrNull;
  final stats = statsAsync.valueOrNull;
  final debtSummary = debtSummaryAsync.valueOrNull;
  final transactions = transactionsAsync.valueOrNull ?? [];

  if (company == null) {
    return DashboardData(
      isProfileSetup: false,
      baseSalary: 0,
      netSalary: 0,
      totalOvertimeValue: 0,
      totalDeficitValue: 0,
      totalDebtPayments: 0,
      totalTransactionsExpenses: 0,
      totalAdjustments: 0,
      debtToSalaryRatio: 0,
    );
  }

  final calculator = SalaryCalculator(company);
  
  final expenses = transactions.where((t) => t.type.name == 'expense').fold(0.0, (sum, t) => sum + t.amount);
  
  final monthly = calculator.calculateMonthly(
    totalOvertimeValue: stats?.totalOvertimeValue ?? 0,
    totalDeficitValue: stats?.totalDeficitValue ?? 0,
    totalDebtPayments: debtSummary?.totalPaidOwe ?? 0,
    totalTransactionsExpenses: expenses,
  );

  final debtToSalaryRatio = company.baseMonthlySalary > 0
      ? (debtSummary?.remainingOwe ?? 0) / company.baseMonthlySalary
      : 0;

  return DashboardData(
    isProfileSetup: true,
    baseSalary: company.baseMonthlySalary,
    netSalary: monthly.net,
    totalOvertimeValue: monthly.overtime,
    totalDeficitValue: monthly.deficit,
    totalDebtPayments: debtSummary?.totalPaidOwe ?? 0,
    totalTransactionsExpenses: expenses,
    totalAdjustments: monthly.adjustments,
    debtToSalaryRatio: debtToSalaryRatio.toDouble(),
    currency: company.currency ?? AppConstants.defaultCurrency,
    expectedWorkingDays: stats?.expectedWorkingDays ?? 0,
    attendedDays: stats?.actualWorkingDays ?? 0,
    absentDays: stats?.absentDays ?? 0,
    requiredHours: stats?.totalRequiredHours ?? 0,
    workedHours: stats?.totalWorkedHours ?? 0,
    overtimeHours: stats?.totalOvertimeHours ?? 0,
    deficitHours:
        (stats?.totalLatenessHours ?? 0) + (stats?.totalAbsenceHours ?? 0),
  );
}

/// مصروفات شهر مجمّعة حسب الفئة، مرتّبة تنازلياً.
///
/// مفصولة عن `dashboardData` حتى لا يعيد تغيّر الرسم حساب الراتب كله.
@riverpod
Future<List<CategoryBreakdownItem>> monthlyExpensesByCategory(
  Ref ref, {
  required int year,
  required int month,
}) async {
  final transactions =
      await ref.watch(monthlyTransactionsProvider(year: year, month: month).future);

  final expenses = transactions
      .where((t) => t.type == TransactionTypeEntity.expense)
      .toList();
  final total = expenses.fold(0.0, (sum, t) => sum + t.amount);
  if (total <= 0) return const [];

  final amounts = <String, double>{};
  final counts = <String, int>{};
  for (final expense in expenses) {
    amounts.update(expense.categoryName, (v) => v + expense.amount,
        ifAbsent: () => expense.amount);
    counts.update(expense.categoryName, (v) => v + 1, ifAbsent: () => 1);
  }

  return [
    for (final entry in amounts.entries)
      CategoryBreakdownItem(
        name: entry.key,
        amount: entry.value,
        share: entry.value / total,
        transactionCount: counts[entry.key]!,
      ),
  ]..sort((a, b) => b.amount.compareTo(a.amount));
}

class DashboardData {
  final bool isProfileSetup;
  final double baseSalary;
  final double netSalary;
  final double totalOvertimeValue;
  final double totalDeficitValue;
  final double totalDebtPayments;
  final double totalTransactionsExpenses;
  final double totalAdjustments;
  final double debtToSalaryRatio;
  final String currency;

  /// أرقام الدوام لهذا الشهر — تُعرض في اللوحة إلى جانب المال، لأن المال
  /// هنا نتيجةٌ لها ولا يُفهم بمعزل عنها.
  final int expectedWorkingDays;
  final int attendedDays;
  final int absentDays;
  final double requiredHours;
  final double workedHours;
  final double overtimeHours;
  final double deficitHours;

  double get completionRate =>
      requiredHours <= 0 ? 0 : workedHours / requiredHours;

  double get attendanceRate =>
      expectedWorkingDays == 0 ? 0 : attendedDays / expectedWorkingDays;

  /// صافي أثر الساعات على الراتب: بدل الإضافي ناقص خصم العجز والغياب.
  double get overtimeValueNet => totalOvertimeValue - totalDeficitValue;

  DashboardData({
    required this.isProfileSetup,
    required this.baseSalary,
    required this.netSalary,
    required this.totalOvertimeValue,
    required this.totalDeficitValue,
    required this.totalDebtPayments,
    required this.totalTransactionsExpenses,
    required this.totalAdjustments,
    required this.debtToSalaryRatio,
    this.currency = AppConstants.defaultCurrency,
    this.expectedWorkingDays = 0,
    this.attendedDays = 0,
    this.absentDays = 0,
    this.requiredHours = 0,
    this.workedHours = 0,
    this.overtimeHours = 0,
    this.deficitHours = 0,
  });
}
