import 'package:isar_community/isar.dart';

part 'profile_model.g.dart';

/// الشخص نفسه — صف مفرد (`id = 0`).
///
/// شروط العمل (الراتب، الجدول، البدلات) انتقلت إلى [CompanyModel]؛ ما يبقى
/// هنا ما لا يتغيّر بتغيّر جهة العمل.
@collection
class ProfileModel {
  Id id = 0;

  late String fullName;

  /// الجهة المعروضة حالياً. كل شاشات الدوام والراتب والتقارير تُقرأ عبرها.
  int? activeCompanyId;

  /// العملة الافتراضية لجهة جديدة؛ لكل جهة أن تخالفها.
  String? currency;

  late DateTime updatedAt;

  // ── حقول ما قبل تعدّد الجهات ───────────────────────────────────
  // تُقرأ مرة واحدة في `CompanyMigration` لبناء الجهة الأولى ثم تُهمل.
  // إبقاؤها يحفظ بيانات من رقّى التطبيق دون أن يفقد راتبه وجدوله.
  String? legacyJobTitle;
  double? legacyBaseMonthlySalary;
  double? legacyHourlyRate;
  double? legacyOvertimeRate;
  List<WorkDayConfig>? legacyWorkSchedule;
  List<SalaryAdjustment>? legacyAdjustments;
  String? legacyCompanyName;
  DateTime? legacyEmploymentStartDate;
}

@embedded
class SalaryAdjustment {
  late String title;
  late double amount;
  late bool isAddition;
}

@embedded
class WorkDayConfig {
  late int dayOfWeek;
  late bool isWorkingDay;
  late int requiredHours;
  late int requiredMinutes;
  late bool isHoliday;

  // إعدادات الوردية
  String? startTime; // صيغة "HH:mm"
  String? endTime;   // صيغة "HH:mm"
  bool isCrossDay = false;
}
