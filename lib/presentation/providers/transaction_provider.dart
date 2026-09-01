import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/local/repositories/transaction_repository_impl.dart';
import '../../domain/entities/transaction_entity.dart';
import 'dashboard_provider.dart';

part 'transaction_provider.g.dart';

@riverpod
TransactionRepositoryImpl transactionRepository(Ref ref) {
  return TransactionRepositoryImpl();
}

@riverpod
Future<List<TransactionEntity>> monthlyTransactions(
  Ref ref, {
  required int year,
  required int month,
}) async {
  final repo = ref.watch(transactionRepositoryProvider);
  return await repo.getMonthlyTransactions(year, month);
}

@riverpod
class TransactionController extends _$TransactionController {
  @override
  FutureOr<void> build() => null;

  Future<void> addTransaction(TransactionEntity entity) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(transactionRepositoryProvider);
      await repo.addTransaction(entity);
      ref.invalidate(monthlyTransactionsProvider);
      ref.invalidate(dashboardDataProvider);
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> deleteTransaction(int id) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(transactionRepositoryProvider);
      await repo.deleteTransaction(id);
      ref.invalidate(monthlyTransactionsProvider);
      ref.invalidate(dashboardDataProvider);
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}
