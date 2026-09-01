import '../../domain/entities/company_entity.dart';

/// كل حسابات المال تجري على جهة عمل واحدة: الراتب والجدول والبدلات كلها
/// خصائصها هي، ولا معنى لحسابها على مستوى الشخص حين يعمل في أكثر من جهة.
class SalaryCalculator {
  final CompanyEntity company;

  SalaryCalculator(this.company);

  double get hourlyWage {
    // استخدام سعر الساعة المدخل يدوياً إذا وجد
    if (company.hourlyRate > 0) return company.hourlyRate;
    
    final totalMonthlyHours = _calculateMonthlyRequiredHours();
    if (totalMonthlyHours == 0) return 0;
    return company.baseMonthlySalary / totalMonthlyHours;
  }

  double get overtimeHourlyRate {
    // إذا كان هناك سعر إضافي محدد يدوياً، نستخدمه، وإلا نحسبه كنسبة
    if (company.overtimeRate > 2) return company.overtimeRate; // اعتباراً أن النسبة عادة 1.5 أو 2.0
    return hourlyWage * company.overtimeRate;
  }

  double _calculateMonthlyRequiredHours() {
    double total = 0;
    for (final day in company.workSchedule) {
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

  /// المبلغ المكتسب حتى الآن من [presenceMinutes] دقيقة تواجد.
  ///
  /// يأخذ الدقائق لا وقت الدخول، لأن اليوم قد يضم عدة جلسات متقطّعة.
  double calculateEarnedFromMinutes(int presenceMinutes, int reqHours, int reqMins) {
    final totalMinutes = presenceMinutes < 0 ? 0 : presenceMinutes;
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

  /// فترة تواجد واحدة، بحدّيها.
  ///
  /// يستخدمها [calculateDayDetails] بدل تمرير الكيانات، حتى تبقى الحاسبة
  /// مستقلة عن طبقة البيانات.
  static ({DateTime start, DateTime end}) presence(DateTime start, DateTime end) =>
      (start: start, end: end);

  /// يحسب الرسمي/الإضافي/العجز ليوم كامل قد يحتوي عدة جلسات.
  ///
  /// داخل نافذة الوردية: مجموع تقاطعات الجلسات معها رسمي، وما خرج عنها
  /// إضافي، والفراغ داخلها عجز — فخروجٌ للغداء يظهر عجزاً كما يجب.
  ///
  /// بلا نافذة (`scheduledStart`/`scheduledEnd` فارغان) تُقارن مدة التواجد
  /// الكلية بالساعات المطلوبة لليوم.
  ({int officialMinutes, int overtimeMinutes, int deficitMinutes}) calculateDayDetails({
    required List<({DateTime start, DateTime end})> sessions,
    required String? scheduledStart,
    required String? scheduledEnd,
    required bool isCrossDay,
    int requiredHours = 0,
    int requiredMinutes = 0,
  }) {
    if (sessions.isEmpty) {
      return (
        officialMinutes: 0,
        overtimeMinutes: 0,
        deficitMinutes: (requiredHours * 60) + requiredMinutes,
      );
    }

    final presenceMinutes = sessions.fold(
      0,
      (sum, session) {
        final minutes = session.end.difference(session.start).inMinutes;
        return sum + (minutes < 0 ? 0 : minutes);
      },
    );

    if (scheduledStart == null || scheduledEnd == null) {
      return _detailsFromDuration(
        presenceMinutes: presenceMinutes,
        requiredMinutes: (requiredHours * 60) + requiredMinutes,
      );
    }

    final anchor = sessions.first.start;
    final windowStart = _atTime(anchor, scheduledStart);
    var windowEnd = _atTime(anchor, scheduledEnd);
    if (isCrossDay) {
      windowEnd = windowEnd.add(const Duration(days: 1));
    }

    var officialMinutes = 0;
    for (final session in sessions) {
      final from =
          session.start.isAfter(windowStart) ? session.start : windowStart;
      final to = session.end.isBefore(windowEnd) ? session.end : windowEnd;
      if (to.isAfter(from)) {
        officialMinutes += to.difference(from).inMinutes;
      }
    }

    final windowMinutes = windowEnd.difference(windowStart).inMinutes;
    final deficitMinutes = windowMinutes - officialMinutes;

    return (
      officialMinutes: officialMinutes,
      // ما تبقّى من التواجد خارج النافذة، قبلها أو بعدها أو بين ورديتين.
      overtimeMinutes: presenceMinutes - officialMinutes,
      deficitMinutes: deficitMinutes < 0 ? 0 : deficitMinutes,
    );
  }

  /// الحالة الخاصة بجلسة واحدة — تبقى للتوافق مع الاستدعاءات القائمة.
  ({int officialMinutes, int overtimeMinutes, int deficitMinutes}) calculateShiftDetails({
    required DateTime actualCheckIn,
    required DateTime actualCheckOut,
    required String? scheduledStart,
    required String? scheduledEnd,
    required bool isCrossDay,
    int requiredHours = 0,
    int requiredMinutes = 0,
  }) {
    return calculateDayDetails(
      sessions: [presence(actualCheckIn, actualCheckOut)],
      scheduledStart: scheduledStart,
      scheduledEnd: scheduledEnd,
      isCrossDay: isCrossDay,
      requiredHours: requiredHours,
      requiredMinutes: requiredMinutes,
    );
  }

  static DateTime _atTime(DateTime day, String hhmm) {
    final parts = hhmm.split(':');
    return DateTime(day.year, day.month, day.day,
        int.parse(parts[0]), int.parse(parts[1]));
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
    for (final adj in company.adjustments) {
      if (adj.isAddition) {
        totalAdjustments += adj.amount;
      } else {
        totalAdjustments -= adj.amount;
      }
    }

    final gross = company.baseMonthlySalary + totalOvertimeValue - totalDeficitValue + totalAdjustments;
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
