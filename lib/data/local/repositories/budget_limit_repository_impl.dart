import 'package:isar_community/isar.dart';

import '../../../domain/entities/budget_limit_entity.dart';
import '../../../domain/repositories/budget_limit_repository.dart';
import '../../models/budget_limit_model.dart';
import '../../models/transaction_model.dart';
import '../../models/profile_model.dart';
import '../../models/company_model.dart';
import '../database/isar_database.dart';

class BudgetLimitRepositoryImpl implements BudgetLimitRepository {
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
  Future<List<BudgetLimitEntity>> getAll() async {
    final isar = await _db;
    final companyId = await _companyId(isar);
    final models =
        await isar.budgetLimitModels
        .filter()
        .companyIdEqualTo(companyId)
        .sortByCategoryName()
        .findAll();
    return models.map(_mapToEntity).toList();
  }

  @override
  Future<void> upsert({
    required String categoryName,
    required double monthlyLimit,
    bool isActive = true,
  }) async {
    final isar = await _db;
    final companyId = await _companyId(isar);
    final now = DateTime.now();
    final existing = await isar.budgetLimitModels
        .filter()
        .companyIdEqualTo(companyId)
        .categoryNameEqualTo(categoryName)
        .findFirst();

    final model = existing ??
        (BudgetLimitModel()
          ..createdAt = now
          ..companyId = companyId);
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
    final companyId = await _companyId(isar);
    final limits =
        await isar.budgetLimitModels
        .filter()
        .companyIdEqualTo(companyId)
        .isActiveEqualTo(true)
        .findAll();
    if (limits.isEmpty) return const [];

    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 0, 23, 59, 59);
    // الترشيح بالجهة إلزامي هنا كما في السقوف نفسها: بدونه تُقاس مصروفات
    // كل الجهات على سقف جهة واحدة، فيظهر التجاوز في جهة لم تُنفق فيها شيئاً.
    final expenses = await isar.transactionModels
        .filter()
        .companyIdEqualTo(companyId)
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
