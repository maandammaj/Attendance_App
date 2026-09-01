import 'package:isar_community/isar.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../../domain/repositories/transaction_repository.dart';
import '../../models/transaction_model.dart';
import '../../models/account_model.dart';
import '../database/isar_database.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  Future<Isar> get _db async => await IsarDatabase.instance;

  @override
  Future<List<TransactionEntity>> getMonthlyTransactions(int year, int month) async {
    final isar = await _db;
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 0);
    
    final models = await isar.transactionModels
        .filter()
        .dateBetween(start, end)
        .sortByDateDesc()
        .findAll();
        
    return models.map(_mapToEntity).toList();
  }

  @override
  Future<void> addTransaction(TransactionEntity entity) async {
    final isar = await _db;
    final model = _mapToModel(entity);
    await isar.writeTxn(() async {
      await isar.transactionModels.put(model);
      
      if (model.accountId != null) {
        final account = await isar.accountModels.get(model.accountId!);
        if (account != null) {
          // المشتريات (expense) تنقص من الرصيد (تزيد الدين عليك)
          // الدخل (income) يزيد من الرصيد
          final change = model.type == TransactionType.expense ? -model.amount : model.amount;
          account.totalBalance += change;
          account.updatedAt = DateTime.now();
          await isar.accountModels.put(account);
        }
      }
    });
  }

  @override
  Future<void> deleteTransaction(int id) async {
    final isar = await _db;
    await isar.writeTxn(() async {
      await isar.transactionModels.delete(id);
    });
  }

  TransactionEntity _mapToEntity(TransactionModel m) {
    return TransactionEntity(
      id: m.id,
      amount: m.amount,
      date: m.date,
      categoryName: m.categoryName,
      categoryId: m.categoryId,
      accountId: m.accountId,
      note: m.note,
      type: m.type == TransactionType.income ? TransactionTypeEntity.income : TransactionTypeEntity.expense,
      isRecurring: m.isRecurring,
      recurringDay: m.recurringDay,
    );
  }

  TransactionModel _mapToModel(TransactionEntity e) {
    return TransactionModel()
      ..id = e.id == 0 ? Isar.autoIncrement : e.id
      ..amount = e.amount
      ..date = e.date
      ..categoryName = e.categoryName
      ..categoryId = e.categoryId
      ..accountId = e.accountId
      ..note = e.note
      ..type = e.type == TransactionTypeEntity.income ? TransactionType.income : TransactionType.expense
      ..isRecurring = e.isRecurring
      ..recurringDay = e.recurringDay;
  }
}
