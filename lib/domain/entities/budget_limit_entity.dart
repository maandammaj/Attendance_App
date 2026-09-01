class BudgetLimitEntity {
  final int id;
  final String categoryName;
  final double monthlyLimit;
  final bool isActive;

  const BudgetLimitEntity({
    required this.id,
    required this.categoryName,
    required this.monthlyLimit,
    this.isActive = true,
  });
}

/// حالة فئة واحدة مقابل حدّها خلال شهر — مصدر تنبيهات تجاوز الميزانية
/// وشرائح شاشة الميزانيات على السواء.
class BudgetStatusEntity {
  final String categoryName;
  final double limit;
  final double spent;

  const BudgetStatusEntity({
    required this.categoryName,
    required this.limit,
    required this.spent,
  });

  double get remaining => limit - spent;
  double get ratio => limit <= 0 ? 0 : spent / limit;
  bool get isOverrun => spent > limit;
}
