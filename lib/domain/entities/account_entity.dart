enum AccountTypeEntity { supplier, customer, friend, personal }

class AccountEntity {
  final int id;
  final String name;
  final AccountTypeEntity type;
  final double totalBalance;
  final String? phoneNumber;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  AccountEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.totalBalance,
    this.phoneNumber,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });
}
