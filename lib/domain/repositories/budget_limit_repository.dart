import '../entities/budget_limit_entity.dart';

abstract class BudgetLimitRepository {
  Future<List<BudgetLimitEntity>> getAll();
  Future<void> upsert({
    required String categoryName,
    required double monthlyLimit,
    bool isActive,
  });
  Future<void> delete(int id);

  /// حالة كل فئة لها حدّ فعّال مقابل مصروفات الشهر المحدد.
  Future<List<BudgetStatusEntity>> getStatus(int year, int month);
}
