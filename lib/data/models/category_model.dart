import 'package:isar_community/isar.dart';

part 'category_model.g.dart';

@collection
class CategoryModel {
  Id id = Isar.autoIncrement;

  late String name;
  late String iconData; // Codepoint as string
  late int colorValue; // ARGB
  late bool isExpense; // true for expense, false for income
}
