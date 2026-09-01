import 'package:isar_community/isar.dart';

import '../../../domain/entities/budget_limit_entity.dart';
import '../../../domain/repositories/budget_limit_repository.dart';
import '../../models/budget_limit_model.dart';
import '../../models/transaction_model.dart';
import '../database/isar_database.dart';

class BudgetLimitRepositoryImpl implements BudgetLimitRepository {
  Future<Isar> get _db async => await IsarDatabase.instance;

  @override
  Future<List<BudgetLimitEntity>> getAll() async {
    final isar = await _db;
    final models =
        await isar.budgetLimitModels.where().sortByCategoryName().findAll();
    return models.map(_mapToEntity).toList();
  }

  @override
  Future<void> upsert({
    required String categoryName,
    required double monthlyLimit,
    bool isActive = true,
  }) async {
    final isar = await _db;
    final now = DateTime.now();
    final existing = await isar.budgetLimitModels
        .filter()
        .categoryNameEqualTo(categoryName)
        .findFirst();

    final model = existing ?? (BudgetLimitModel()..createdAt = now);
    model
      ..categoryName = categoryName
      ..monthlyLimit = monthlyLimit
      ..isActive = isActive
      ..updatedAt = now;

    await isar.writeTxn(() async {
      await isar.budgetLimitModels.put(model);
    });
  }

  @override
  Future<void> delete(int id) async {
    final isar = await _db;
    await isar.writeTxn(() async {
      await isar.budgetLimitModels.delete(id);
    });
  }

  @override
  Future<List<BudgetStatusEntity>> getStatus(int year, int month) async {
    final isar = await _db;
    final limits =
        await isar.budgetLimitModels.filter().isActiveEqualTo(true).findAll();
    if (limits.isEmpty) return const [];

    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 0, 23, 59, 59);
    final expenses = await isar.transactionModels
        .filter()
        .typeEqualTo(TransactionType.expense)
        .dateBetween(start, end)
        .findAll();

    final spentByCategory = <String, double>{};
    for (final expense in expenses) {
      spentByCategory.update(
        expense.categoryName,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    return limits
        .map((limit) => BudgetStatusEntity(
              categoryName: limit.categoryName,
              limit: limit.monthlyLimit,
              spent: spentByCategory[limit.categoryName] ?? 0,
            ))
        .toList()
      ..sort((a, b) => b.ratio.compareTo(a.ratio));
  }

  BudgetLimitEntity _mapToEntity(BudgetLimitModel m) {
    return BudgetLimitEntity(
      id: m.id,
      categoryName: m.categoryName,
      monthlyLimit: m.monthlyLimit,
      isActive: m.isActive,
    );
  }
}
