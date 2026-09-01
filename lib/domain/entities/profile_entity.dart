/// الشخص. شروط العمل في [CompanyEntity].
class ProfileEntity {
  final int id;
  final String fullName;

  /// الجهة المعروضة حالياً، أو null قبل إنشاء أي جهة.
  final int? activeCompanyId;

  /// العملة الافتراضية لجهة جديدة.
  final String? currency;

  final DateTime updatedAt;

  ProfileEntity({
    required this.id,
    required this.fullName,
    this.activeCompanyId,
    this.currency,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime(2020);

  ProfileEntity copyWith({
    String? fullName,
    int? activeCompanyId,
    String? currency,
  }) {
    return ProfileEntity(
      id: id,
      fullName: fullName ?? this.fullName,
      activeCompanyId: activeCompanyId ?? this.activeCompanyId,
      currency: currency ?? this.currency,
      updatedAt: DateTime.now(),
    );
  }
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

  const WorkDayConfigEntity({
    required this.dayOfWeek,
    required this.isWorkingDay,
    required this.requiredHours,
    required this.requiredMinutes,
    required this.isHoliday,
    this.startTime,
    this.endTime,
    this.isCrossDay = false,
  });

  int get requiredMinutesTotal => (requiredHours * 60) + requiredMinutes;

  bool get hasShiftWindow => startTime != null && endTime != null;

  /// طول نافذة الوردية بالدقائق، أو null بلا نافذة.
  ///
  /// الوردية العابرة لمنتصف الليل تُحسب بإضافة يوم كامل قبل الطرح.
  int? get windowMinutes {
    if (!hasShiftWindow) return null;
    final start = _minutesOf(startTime!);
    final end = _minutesOf(endTime!);
    final span = end - start;
    return span <= 0 ? span + (24 * 60) : span;
  }

  static int _minutesOf(String hhmm) {
    final parts = hhmm.split(':');
    return (int.parse(parts[0]) * 60) + int.parse(parts[1]);
  }

  /// `clearWindow` يلزم لأن `startTime`/`endTime` قابلان للإفراغ، ولا يمكن
  /// التعبير عن "امسحه" بتمرير null في copyWith عادية.
  WorkDayConfigEntity copyWith({
    bool? isWorkingDay,
    int? requiredHours,
    int? requiredMinutes,
    bool? isHoliday,
    String? startTime,
    String? endTime,
    bool? isCrossDay,
    bool clearWindow = false,
  }) {
    return WorkDayConfigEntity(
      dayOfWeek: dayOfWeek,
      isWorkingDay: isWorkingDay ?? this.isWorkingDay,
      requiredHours: requiredHours ?? this.requiredHours,
      requiredMinutes: requiredMinutes ?? this.requiredMinutes,
      isHoliday: isHoliday ?? this.isHoliday,
      startTime: clearWindow ? null : (startTime ?? this.startTime),
      endTime: clearWindow ? null : (endTime ?? this.endTime),
      isCrossDay: clearWindow ? false : (isCrossDay ?? this.isCrossDay),
    );
  }
}
