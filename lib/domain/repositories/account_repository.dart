import '../entities/account_entity.dart';

abstract class AccountRepository {
  Future<List<AccountEntity>> getAllAccounts();
  Future<AccountEntity?> getAccountById(int id);
  Future<void> saveAccount(AccountEntity entity);
  Future<void> updateBalance(int id, double amountChange); // Positive to add, negative to subtract
  Future<void> deleteAccount(int id);
}
