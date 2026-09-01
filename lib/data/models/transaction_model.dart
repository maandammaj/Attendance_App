import 'package:isar_community/isar.dart';

part 'transaction_model.g.dart';

@collection
class TransactionModel {
  Id id = Isar.autoIncrement;

  late double amount;
  late DateTime date;
  late String categoryName;
  late int categoryId;
  int? accountId; // Link to AccountModel
  String? note;
  
  @enumerated
  late TransactionType type;
  
  bool isRecurring = false;
  int? recurringDay; // 1-31
}

enum TransactionType { income, expense }
