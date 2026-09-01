class DebtEntity {
  final int id;
  final String debtType;
  final String personName;
  final int? accountId;
  final String? personPhone;
  final String? personAvatar;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final DateTime createdAt;
  final DateTime? dueDate;
  final DateTime? lastPaymentDate;
  final String? description;
  final String? category;
  final String status;
  final List<PaymentRecordEntity> paymentHistory;
  final bool? hasReminder;
  final DateTime? reminderDate;

  DebtEntity({
    required this.id,
    required this.debtType,
    required this.personName,
    this.accountId,
    this.personPhone,
    this.personAvatar,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.createdAt,
    this.dueDate,
    this.lastPaymentDate,
    this.description,
    this.category,
    required this.status,
    required this.paymentHistory,
    this.hasReminder,
    this.reminderDate,
  });
}

class PaymentRecordEntity {
  final double amount;
  final DateTime date;
  final String? note;

  PaymentRecordEntity({
    required this.amount,
    required this.date,
    this.note,
  });
}