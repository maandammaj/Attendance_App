import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'attendance_provider.dart';
import 'debt_provider.dart';
import 'profile_provider.dart';
import 'transaction_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/salary_calculator.dart';

part 'dashboard_provider.g.dart';

@riverpod
Future<DashboardData> dashboardData(Ref ref) async {
  final now = DateTime.now();
  final profileAsync = ref.watch(profileProvider);
  final statsAsync = ref.watch(attendanceStatsProvider(year: now.year, month: now.month));
  final debtSummaryAsync = ref.watch(debtSummaryProvider);
  final transactionsAsync = ref.watch(monthlyTransactionsProvider(year: now.year, month: now.month));

  final profile = profileAsync.valueOrNull;
  final stats = statsAsync.valueOrNull;
  final debtSummary = debtSummaryAsync.valueOrNull;
  final transactions = transactionsAsync.valueOrNull ?? [];

  if (profile == null) {
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

  final calculator = SalaryCalculator(profile);
  
  final expenses = transactions.where((t) => t.type.name == 'expense').fold(0.0, (sum, t) => sum + t.amount);
  
  final monthly = calculator.calculateMonthly(
    totalOvertimeValue: stats?.totalOvertimeValue ?? 0,
    totalDeficitValue: stats?.totalDeficitValue ?? 0,
    totalDebtPayments: debtSummary?.totalPaidOwe ?? 0,
    totalTransactionsExpenses: expenses,
  );

  final debtToSalaryRatio = profile.baseMonthlySalary > 0
      ? (debtSummary?.remainingOwe ?? 0) / profile.baseMonthlySalary
      : 0;

  return DashboardData(
    isProfileSetup: true,
    baseSalary: profile.baseMonthlySalary,
    netSalary: monthly.net,
    totalOvertimeValue: monthly.overtime,
    totalDeficitValue: monthly.deficit,
    totalDebtPayments: debtSummary?.totalPaidOwe ?? 0,
    totalTransactionsExpenses: expenses,
    totalAdjustments: monthly.adjustments,
    debtToSalaryRatio: debtToSalaryRatio.toDouble(),
    currency: profile.currency ?? AppConstants.defaultCurrency,
  );
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
  });
}
