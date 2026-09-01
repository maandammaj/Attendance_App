import 'package:isar_community/isar.dart';
import '../../../domain/entities/account_entity.dart';
import '../../../domain/repositories/account_repository.dart';
import '../../models/account_model.dart';
import '../database/isar_database.dart';

class AccountRepositoryImpl implements AccountRepository {
  Future<Isar> get _db async => await IsarDatabase.instance;

  @override
  Future<List<AccountEntity>> getAllAccounts() async {
    final isar = await _db;
    final models = await isar.accountModels.where().sortByUpdatedAtDesc().findAll();
    return models.map(_mapToEntity).toList();
  }

  @override
  Future<AccountEntity?> getAccountById(int id) async {
    final isar = await _db;
    final model = await isar.accountModels.get(id);
    return model != null ? _mapToEntity(model) : null;
  }

  @override
  Future<void> saveAccount(AccountEntity entity) async {
    final isar = await _db;
    final model = _mapToModel(entity);
    await isar.writeTxn(() async {
      await isar.accountModels.put(model);
    });
  }

  @override
  Future<void> updateBalance(int id, double amountChange) async {
    final isar = await _db;
    await isar.writeTxn(() async {
      final account = await isar.accountModels.get(id);
      if (account != null) {
        account.totalBalance += amountChange;
        account.updatedAt = DateTime.now();
        await isar.accountModels.put(account);
      }
    });
  }

  @override
  Future<void> deleteAccount(int id) async {
    final isar = await _db;
    await isar.writeTxn(() async {
      await isar.accountModels.delete(id);
    });
  }

  AccountEntity _mapToEntity(AccountModel m) {
    return AccountEntity(
      id: m.id,
      name: m.name,
      type: AccountTypeEntity.values[m.type.index],
      totalBalance: m.totalBalance,
      phoneNumber: m.phoneNumber,
      note: m.note,
      createdAt: m.createdAt,
      updatedAt: m.updatedAt,
    );
  }

  AccountModel _mapToModel(AccountEntity e) {
    return AccountModel()
      ..id = e.id == 0 ? Isar.autoIncrement : e.id
      ..name = e.name
      ..type = AccountType.values[e.type.index]
      ..totalBalance = e.totalBalance
      ..phoneNumber = e.phoneNumber
      ..note = e.note
      ..createdAt = e.createdAt
      ..updatedAt = e.updatedAt;
  }
}
