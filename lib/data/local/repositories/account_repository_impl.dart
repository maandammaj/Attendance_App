import 'package:isar_community/isar.dart';
import '../../../domain/entities/account_entity.dart';
import '../../../domain/repositories/account_repository.dart';
import '../../models/account_model.dart';
import '../../models/profile_model.dart';
import '../../models/company_model.dart';
import '../database/isar_database.dart';

class AccountRepositoryImpl implements AccountRepository {
  Future<Isar> get _db async => await IsarDatabase.instance;

  /// معرّف الجهة الفعّالة — كل استعلام وكل كتابة تمرّ به، فبيانات جهة لا
  /// تظهر أبداً في أخرى.
  Future<int> _companyId(Isar isar) async {
    final profile = await isar.profileModels.get(0);
    final id = profile?.activeCompanyId;
    if (id != null) return id;

    final fallback = await isar.companyModels
        .filter()
        .isArchivedEqualTo(false)
        .findFirst();
    if (fallback == null) throw Exception('لم تُحدَّد جهة عمل');
    return fallback.id;
  }


  @override
  Future<List<AccountEntity>> getAllAccounts() async {
    final isar = await _db;
    final companyId = await _companyId(isar);
    final models = await isar.accountModels
        .filter()
        .companyIdEqualTo(companyId)
        .sortByUpdatedAtDesc()
        .findAll();
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
    final model = _mapToModel(entity)..companyId = await _companyId(isar);
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
