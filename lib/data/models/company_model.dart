import 'package:isar_community/isar.dart';

import 'profile_model.dart';

part 'company_model.g.dart';

/// جهة عمل واحدة بشروطها كاملة.
///
/// كل ما يخص علاقة العمل يعيش هنا لا في `ProfileModel`: الراتب وجدول الدوام
/// والبدلات. الشخص واحد وقد يعمل في أكثر من جهة، فالفصل يجعل كل جهة تُحسب
/// وتُقرَّر عليها بمعزل عن الأخرى.
@collection
class CompanyModel {
  Id id = Isar.autoIncrement;

  late String name;
  late String jobTitle;

  late double baseMonthlySalary;
  late double hourlyRate;
  late double overtimeRate;

  late List<WorkDayConfig> workSchedule;
  late List<SalaryAdjustment> adjustments;

  String? currency;
  DateTime? employmentStartDate;

  /// لون تمييز الجهة في القوائم والرسوم — فهرس داخل `AppPalette.categorical`.
  int colorIndex = 0;

  /// جهة منتهية: تبقى سجلاتها وتقاريرها ولا تظهر في التبديل السريع.
  @Index()
  bool isArchived = false;

  late DateTime createdAt;
  late DateTime updatedAt;
}
