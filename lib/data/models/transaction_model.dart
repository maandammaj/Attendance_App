import 'package:isar_community/isar.dart';

part 'transaction_model.g.dart';

@collection
class TransactionModel {

  /// الجهة التي تخصّها هذه البيانات. مفهرس لأن كل استعلام يُرشّح به.
  @Index()
  int companyId = 0;
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
