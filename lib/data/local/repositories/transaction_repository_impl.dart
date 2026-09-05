import 'package:isar_community/isar.dart';
import '../../../core/utils/date_helpers.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../../domain/repositories/transaction_repository.dart';
import '../../models/transaction_model.dart';
import '../../models/account_model.dart';
import '../database/company_scope.dart';
import '../database/isar_database.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  Future<Isar> get _db async => await IsarDatabase.instance;


  @override
  Future<List<TransactionEntity>> getMonthlyTransactions(int year, int month) {
    return getTransactionsBetween(
      DateTime(year, month, 1),
      DateHelpers.endOfMonth(DateTime(year, month, 1)),
    );
  }

  @override
  Future<List<TransactionEntity>> getTransactionsBetween(
      DateTime from, DateTime to) async {
    final isar = await _db;
    final companyId = await CompanyScope.activeId(isar);
    final models = await isar.transactionModels
        .filter()
        .companyIdEqualTo(companyId)
        .dateBetween(from, to)
        .sortByDateDesc()
        .findAll();

    return models.map(_mapToEntity).toList();
  }

  @override
  Future<void> addTransaction(TransactionEntity entity) async {
    final isar = await _db;
    final model = _mapToModel(entity)..companyId = await CompanyScope.activeId(isar);
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
    final companyId = await CompanyScope.activeId(isar);
    final model = await isar.transactionModels.get(id);
    CompanyScope.assertOwned(
      recordCompanyId: model?.companyId,
      activeCompanyId: companyId,
      subject: 'هذه الحركة',
    );

    await isar.writeTxn(() async {
      // عكس أثر الحركة على الحساب قبل حذفها. الإضافة كانت تعدّل الرصيد
      // والحذف لا يعكسه، فكل حركة محذوفة كانت تترك رصيد الحساب مائلاً
      // بمقدارها إلى الأبد — والفارق لا يظهر في أي شاشة تشرح سببه.
      if (model!.accountId != null) {
        final account = await isar.accountModels.get(model.accountId!);
        if (account != null) {
          final applied =
              model.type == TransactionType.expense ? -model.amount : model.amount;
          account.totalBalance -= applied;
          account.updatedAt = DateTime.now();
          await isar.accountModels.put(account);
        }
      }
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
