enum TransactionTypeEntity { income, expense }

class TransactionEntity {
  final int id;
  final double amount;
  final DateTime date;
  final String categoryName;
  final int categoryId;
  final int? accountId;
  final String? note;
  final TransactionTypeEntity type;
  final bool isRecurring;
  final int? recurringDay;

  TransactionEntity({
    required this.id,
    required this.amount,
    required this.date,
    required this.categoryName,
    required this.categoryId,
    this.accountId,
    this.note,
    required this.type,
    this.isRecurring = false,
    this.recurringDay,
  });
}
