class ProfileEntity {
  final int id;
  final String fullName;
  final String jobTitle;
  final double baseMonthlySalary;
  final double hourlyRate;
  final double overtimeRate;
  final List<WorkDayConfigEntity> workSchedule;
  final List<SalaryAdjustmentEntity> adjustments;
  final String? currency;
  final String? companyName;
  final DateTime? employmentStartDate;
  final DateTime updatedAt;

  ProfileEntity({
    required this.id,
    required this.fullName,
    required this.jobTitle,
    required this.baseMonthlySalary,
    required this.hourlyRate,
    required this.overtimeRate,
    required this.workSchedule,
    required this.adjustments,
    this.currency,
    this.companyName,
    this.employmentStartDate,
    required this.updatedAt,
  });
}

class SalaryAdjustmentEntity {
  final String title;
  final double amount;
  final bool isAddition;

  SalaryAdjustmentEntity({
    required this.title,
    required this.amount,
    required this.isAddition,
  });
}

class WorkDayConfigEntity {
  final int dayOfWeek;
  final bool isWorkingDay;
  final int requiredHours;
  final int requiredMinutes;
  final bool isHoliday;
  final String? startTime;
  final String? endTime;
  final bool isCrossDay;

  WorkDayConfigEntity({
    required this.dayOfWeek,
    required this.isWorkingDay,
    required this.requiredHours,
    required this.requiredMinutes,
    required this.isHoliday,
    this.startTime,
    this.endTime,
    this.isCrossDay = false,
  });
}
