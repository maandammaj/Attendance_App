import 'package:isar_community/isar.dart';
import '../../../domain/entities/debt_entity.dart';
import '../../../domain/repositories/debt_repository.dart';
import '../../models/debt_model.dart';
import '../../models/account_model.dart';
import '../database/company_scope.dart';
import '../database/isar_database.dart';

class DebtRepositoryImpl implements DebtRepository {
  Future<Isar> get _db async => await IsarDatabase.instance;


  @override
  Future<List<DebtEntity>> getAllDebts() async {
    final isar = await _db;
    final companyId = await CompanyScope.activeId(isar);
    final debts = await isar.debtModels
        .filter()
        .companyIdEqualTo(companyId)
        .sortByCreatedAtDesc()
        .findAll();
    return debts.map(_mapToEntity).toList();
  }

  @override
  Future<List<DebtEntity>> getDebtsByType(String type) async {
    final isar = await _db;
    final companyId = await CompanyScope.activeId(isar);
    final debtType = type == 'owe' ? DebtType.owe : DebtType.owed;
    final debts = await isar.debtModels
        .filter()
        .companyIdEqualTo(companyId)
        .debtTypeEqualTo(debtType)
        .sortByCreatedAtDesc()
        .findAll();
    return debts.map(_mapToEntity).toList();
  }

  @override
  Future<void> addDebt(DebtEntity entity) async {
    final isar = await _db;
    final model = _mapToModel(entity)..companyId = await CompanyScope.activeId(isar);
    await isar.writeTxn(() async {
      await isar.debtModels.put(model);
    });
  }

  @override
  Future<void> updateDebt(DebtEntity entity) async {
    final isar = await _db;
    final model = _mapToModel(entity)..companyId = await CompanyScope.activeId(isar);
    await isar.writeTxn(() async {
      await isar.debtModels.put(model);
    });
  }

  @override
  Future<void> addPayment(int debtId, double amount, String? note) async {
    final isar = await _db;
    final companyId = await CompanyScope.activeId(isar);
    final debt = await isar.debtModels.get(debtId);
    CompanyScope.assertOwned(
      recordCompanyId: debt?.companyId,
      activeCompanyId: companyId,
      subject: 'هذا الدين',
    );

    await isar.writeTxn(() async {
      debt!.paidAmount += amount;
      debt.remainingAmount = debt.totalAmount - debt.paidAmount;
      debt.lastPaymentDate = DateTime.now();

      if (debt.remainingAmount <= 0) {
        debt.status = DebtStatus.paid;
        debt.remainingAmount = 0;
      } else if (debt.paidAmount > 0) {
        debt.status = DebtStatus.partiallyPaid;
      }

      final payment = PaymentRecord()
        ..amount = amount
        ..date = DateTime.now()
        ..note = note;

      debt.paymentHistory = [...(debt.paymentHistory ?? []), payment];

      await isar.debtModels.put(debt);

      if (debt.accountId != null) {
        final account = await isar.accountModels.get(debt.accountId!);
        if (account != null) {
          final change = debt.debtType == DebtType.owe ? amount : -amount;
          account.totalBalance += change;
          account.updatedAt = DateTime.now();
          await isar.accountModels.put(account);
        }
      }
    });
  }

  @override
  Future<void> deleteDebt(int id) async {
    final isar = await _db;
    final companyId = await CompanyScope.activeId(isar);
    final debt = await isar.debtModels.get(id);
    CompanyScope.assertOwned(
      recordCompanyId: debt?.companyId,
      activeCompanyId: companyId,
      subject: 'هذا الدين',
    );

    await isar.writeTxn(() async {
      await isar.debtModels.delete(id);
    });
  }

  DebtEntity _mapToEntity(DebtModel m) {
    return DebtEntity(
      id: m.id,
      debtType: m.debtType.name,
      personName: m.personName,
      accountId: m.accountId,
      personPhone: m.personPhone,
      personAvatar: m.personAvatar,
      totalAmount: m.totalAmount,
      paidAmount: m.paidAmount,
      remainingAmount: m.remainingAmount,
      createdAt: m.createdAt,
      dueDate: m.dueDate,
      lastPaymentDate: m.lastPaymentDate,
      description: m.description,
      category: m.category,
      status: m.status.name,
      paymentHistory: m.paymentHistory
          ?.map((p) => PaymentRecordEntity(
        amount: p.amount,
        date: p.date,
        note: p.note,
      ))
          .toList() ??
          [],
      hasReminder: m.hasReminder,
      reminderDate: m.reminderDate,
    );
  }

  DebtModel _mapToModel(DebtEntity e) {
    final model = DebtModel()
      ..id = e.id == 0 ? Isar.autoIncrement : e.id
      ..debtType = e.debtType == 'owe' ? DebtType.owe : DebtType.owed
      ..personName = e.personName
      ..accountId = e.accountId
      ..personPhone = e.personPhone
      ..personAvatar = e.personAvatar
      ..totalAmount = e.totalAmount
      ..paidAmount = e.paidAmount
      ..remainingAmount = e.remainingAmount
      ..createdAt = e.createdAt
      ..dueDate = e.dueDate
      ..lastPaymentDate = e.lastPaymentDate
      ..description = e.description
      ..category = e.category
      ..status = DebtStatus.values.byName(e.status)
      ..hasReminder = e.hasReminder
      ..reminderDate = e.reminderDate;

    model.paymentHistory = e.paymentHistory
        .map((p) => PaymentRecord()
      ..amount = p.amount
      ..date = p.date
      ..note = p.note)
        .toList();

    return model;
  }
}