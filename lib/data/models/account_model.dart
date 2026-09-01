import 'package:isar_community/isar.dart';

part 'account_model.g.dart';

@collection
class AccountModel {
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
