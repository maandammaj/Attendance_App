import 'package:isar_community/isar.dart';

part 'profile_model.g.dart';

@collection
class ProfileModel {
  Id id = 0;

  late String fullName;
  late String jobTitle;
  late double baseMonthlySalary;
  late double hourlyRate;
  late double overtimeRate;
  late List<WorkDayConfig> workSchedule;
  late List<SalaryAdjustment> adjustments;
  String? currency;
  String? companyName;
  DateTime? employmentStartDate;
  late DateTime updatedAt;
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
