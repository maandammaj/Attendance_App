import '../entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<List<TransactionEntity>> getMonthlyTransactions(int year, int month);
  Future<void> addTransaction(TransactionEntity entity);
  Future<void> deleteTransaction(int id);
}
