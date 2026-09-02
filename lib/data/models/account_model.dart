import 'package:isar_community/isar.dart';

part 'account_model.g.dart';

@collection
class AccountModel {

  /// الجهة التي تخصّها هذه البيانات. مفهرس لأن كل استعلام يُرشّح به.
  @Index()
  int companyId = 0;
  Id id = Isar.autoIncrement;

  late String name;
  
  @enumerated
  late AccountType type;

  late double totalBalance; // Positive: They owe you, Negative: You owe them
  
  String? phoneNumber;
  String? note;
  
  late DateTime createdAt;
  late DateTime updatedAt;
}

enum AccountType { supplier, customer, friend, personal }
