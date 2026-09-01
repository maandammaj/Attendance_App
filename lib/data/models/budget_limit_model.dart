import 'package:isar_community/isar.dart';

part 'budget_limit_model.g.dart';

/// حد إنفاق شهري لفئة واحدة، هو أساس تنبيهات تجاوز الميزانية.
@collection
class BudgetLimitModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String categoryName;

  late double monthlyLimit;

  bool isActive = true;

  late DateTime createdAt;
  late DateTime updatedAt;
}
