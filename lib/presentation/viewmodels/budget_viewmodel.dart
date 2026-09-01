// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../data/local/database/isar_database.dart';
// import '../../data/models/budget_model.dart';
// import '../../data/repositories/budget_repository.dart';
//
// // 1. مزود المستودع مع تحديد النوع الصريح
// final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
//   final isar = ref.watch(isarProvider);
//   return BudgetRepository(isar);
// });
//
// // 2. مزود إدارة الحالة للـ BudgetViewModel
// final budgetViewModelProvider =
// StateNotifierProvider<BudgetViewModel, AsyncValue<BudgetState>>((ref) {
//   final repo = ref.watch(budgetRepositoryProvider);
//   return BudgetViewModel(repo);
// });
//
// class BudgetState {
//   final List<BudgetModel> transactions;
//   final double totalDebt;
//   final double totalIncome;
//
//   BudgetState({
//     required this.transactions,
//     required this.totalDebt,
//     required this.totalIncome,
//   });
// }
//
// class BudgetViewModel extends StateNotifier<AsyncValue<BudgetState>> {
//   final BudgetRepository _repository;
//
//   BudgetViewModel(this._repository) : super(const AsyncValue.loading());
//
//   Future<void> loadMonth(String monthYear) async {
//     state = const AsyncValue.loading();
//     try {
//       final transactions = await _repository.getMonthBudget(monthYear);
//       final debt = await _repository.getTotalDebt(monthYear);
//       final income = transactions
//           .where((t) => !t.isDebt)
//           .fold(0.0, (sum, t) => sum + t.amount);
//
//       state = AsyncValue.data(BudgetState(
//         transactions: transactions,
//         totalDebt: debt,
//         totalIncome: income,
//       ));
//     } catch (e, st) {
//       state = AsyncValue.error(e, st);
//     }
//   }
//
//   Future<void> addTransaction(
//       String title, double amount, bool isDebt, String category) async {
//     final now = DateTime.now();
//     final monthYear = '${now.year}-${now.month.toString().padLeft(2, '0')}';
//
//     final transaction = BudgetModel()
//       ..title = title
//       ..amount = amount
//       ..isDebt = isDebt
//       ..date = now
//       ..category = category
//       ..monthYear = monthYear;
//
//     await _repository.addTransaction(transaction);
//     await loadMonth(monthYear);
//   }
// }