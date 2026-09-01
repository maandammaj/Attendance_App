import '../../domain/entities/profile_entity.dart';

class SalaryCalculator {
  final ProfileEntity profile;

  SalaryCalculator(this.profile);

  double get hourlyWage {
    // استخدام سعر الساعة المدخل يدوياً إذا وجد
    if (profile.hourlyRate > 0) return profile.hourlyRate;
    
    final totalMonthlyHours = _calculateMonthlyRequiredHours();
    if (totalMonthlyHours == 0) return 0;
    return profile.baseMonthlySalary / totalMonthlyHours;
  }

  double get overtimeHourlyRate {
    // إذا كان هناك سعر إضافي محدد يدوياً، نستخدمه، وإلا نحسبه كنسبة
    if (profile.overtimeRate > 2) return profile.overtimeRate; // اعتباراً أن النسبة عادة 1.5 أو 2.0
    return hourlyWage * profile.overtimeRate;
  }

  double _calculateMonthlyRequiredHours() {
    double total = 0;
    for (final day in profile.workSchedule) {
      if (day.isWorkingDay && !day.isHoliday) {
        total += day.requiredHours + (day.requiredMinutes / 60);
      }
    }
    return total * 4.33; 
  }

  double calculateOvertimeValue(int hours, int minutes) {
    final totalHours = hours + (minutes / 60);
    return totalHours * overtimeHourlyRate;
  }

  double calculateDeficitValue(int hours, int minutes) {
    final totalHours = hours + (minutes / 60);
    return totalHours * hourlyWage;
  }

  double calculateCurrentEarned(DateTime checkIn, DateTime now, int reqHours, int reqMins) {
    final totalMinutes = now.difference(checkIn).inMinutes;
    final reqTotalMinutes = (reqHours * 60) + reqMins;

    if (totalMinutes <= reqTotalMinutes) {
      return (totalMinutes / 60) * hourlyWage;
    } else {
      final regValue = (reqTotalMinutes / 60) * hourlyWage;
      final extraMins = totalMinutes - reqTotalMinutes;
      final extraValue = (extraMins / 60) * overtimeHourlyRate;
      return regValue + extraValue;
    }
  }

  /// يحسب الرسمي/الإضافي/العجز لوردية واحدة.
  ///
  /// عند غياب نافذة الوردية (`scheduledStart`/`scheduledEnd`) لا يمكن التقاطع،
  /// فنقارن مدة التواجد الكلية بالساعات المطلوبة لليوم بدل إرجاع أصفار.
  ({int officialMinutes, int overtimeMinutes, int deficitMinutes}) calculateShiftDetails({
    required DateTime actualCheckIn,
    required DateTime actualCheckOut,
    required String? scheduledStart, // "HH:mm"
    required String? scheduledEnd,   // "HH:mm"
    required bool isCrossDay,
    int requiredHours = 0,
    int requiredMinutes = 0,
  }) {
    if (scheduledStart == null || scheduledEnd == null) {
      return _detailsFromDuration(
        presenceMinutes: actualCheckOut.difference(actualCheckIn).inMinutes,
        requiredMinutes: (requiredHours * 60) + requiredMinutes,
      );
    }

    final startParts = scheduledStart.split(':');
    final endParts = scheduledEnd.split(':');
    
    DateTime sStart = DateTime(actualCheckIn.year, actualCheckIn.month, actualCheckIn.day, 
        int.parse(startParts[0]), int.parse(startParts[1]));
    DateTime sEnd = DateTime(actualCheckIn.year, actualCheckIn.month, actualCheckIn.day, 
        int.parse(endParts[0]), int.parse(endParts[1]));
    
    if (isCrossDay) {
      sEnd = sEnd.add(const Duration(days: 1));
    }

    // النافذة الرسمية
    final windowStart = sStart;
    final windowEnd = sEnd;

    // فترة التواجد الفعلي
    final presenceStart = actualCheckIn;
    final presenceEnd = actualCheckOut;

    // التقاطع (الساعات الرسمية المحققة)
    final intersectionStart = presenceStart.isAfter(windowStart) ? presenceStart : windowStart;
    final intersectionEnd = presenceEnd.isBefore(windowEnd) ? presenceEnd : windowEnd;

    int officialMins = 0;
    if (intersectionEnd.isAfter(intersectionStart)) {
      officialMins = intersectionEnd.difference(intersectionStart).inMinutes;
    }

    // العجز (المسافة داخل النافذة التي لم يتواجد فيها)
    final totalRequiredMinutes = windowEnd.difference(windowStart).inMinutes;
    int deficitMins = totalRequiredMinutes - officialMins;
    if (deficitMins < 0) deficitMins = 0;

    // الإضافي (المسافة خارج النافذة التي تواجد فيها)
    int overtimeMins = 0;
    // قبل البداية
    if (presenceStart.isBefore(windowStart)) {
      overtimeMins += windowStart.difference(presenceStart).inMinutes;
    }
    // بعد النهاية
    if (presenceEnd.isAfter(windowEnd)) {
      overtimeMins += presenceEnd.difference(windowEnd).inMinutes;
    }

    return (
      officialMinutes: officialMins,
      overtimeMinutes: overtimeMins,
      deficitMinutes: deficitMins,
    );
  }

  ({int officialMinutes, int overtimeMinutes, int deficitMinutes}) _detailsFromDuration({
    required int presenceMinutes,
    required int requiredMinutes,
  }) {
    final presence = presenceMinutes < 0 ? 0 : presenceMinutes;
    final official = presence < requiredMinutes ? presence : requiredMinutes;
    return (
      officialMinutes: official,
      overtimeMinutes: presence - official,
      deficitMinutes: requiredMinutes - official,
    );
  }

  ({double gross, double net, double overtime, double deficit, double adjustments}) calculateMonthly({
    required double totalOvertimeValue,
    required double totalDeficitValue,
    required double totalDebtPayments,
    required double totalTransactionsExpenses,
  }) {
    double totalAdjustments = 0;
    for (final adj in profile.adjustments) {
      if (adj.isAddition) {
        totalAdjustments += adj.amount;
      } else {
        totalAdjustments -= adj.amount;
      }
    }

    final gross = profile.baseMonthlySalary + totalOvertimeValue - totalDeficitValue + totalAdjustments;
    final net = gross - totalDebtPayments - totalTransactionsExpenses;
    
    return (
      gross: gross,
      net: net,
      overtime: totalOvertimeValue,
      deficit: totalDeficitValue,
      adjustments: totalAdjustments,
    );
  }
}
