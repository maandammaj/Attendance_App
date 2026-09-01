import '../entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<List<TransactionEntity>> getMonthlyTransactions(int year, int month);

  /// معاملات ضمن مدى تواريخ شامل الطرفين — أساس تقارير المدى المخصص.
  Future<List<TransactionEntity>> getTransactionsBetween(DateTime from, DateTime to);

  Future<void> addTransaction(TransactionEntity entity);
  Future<void> deleteTransaction(int id);
}
