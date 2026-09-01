import 'package:isar_community/isar.dart';

part 'debt_model.g.dart';

@collection
class DebtModel {
  Id id = Isar.autoIncrement;

  @enumerated
  late DebtType debtType;

  late String personName;
  int? accountId; // Link to AccountModel
  String? personPhone;
  String? personAvatar;

  late double totalAmount;
  late double paidAmount;
  late double remainingAmount;

  late DateTime createdAt;
  DateTime? dueDate;
  DateTime? lastPaymentDate;

  String? description;
  String? category;

  @enumerated
  late DebtStatus status;

  List<PaymentRecord>? paymentHistory;
  bool? hasReminder;
  DateTime? reminderDate;
}

@embedded
class PaymentRecord {
  late double amount;
  late DateTime date;
  String? note;
}

enum DebtType { owe, owed }
enum DebtStatus { active, partiallyPaid, paid, overdue }