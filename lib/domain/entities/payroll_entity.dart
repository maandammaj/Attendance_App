import 'company_entity.dart';

/// دخل المستخدم من جهة واحدة في فترة.
class WorkplacePayroll {
  const WorkplacePayroll({
    required this.company,
    required this.basic,
    required this.overtime,
    required this.deductions,
    required this.adjustments,
    required this.workedMinutes,
    required this.overtimeMinutes,
    required this.attendedDays,
  });

  final CompanyEntity company;

  /// الأساسي المستحق عن الفترة.
  final double basic;

  final double overtime;

  /// ما خُصم: العجز والغياب.
  final double deductions;

  /// صافي البدلات والاستقطاعات المُعلَنة على الجهة.
  final double adjustments;

  final int workedMinutes;
  final int overtimeMinutes;
  final int attendedDays;

  double get net => basic + overtime + adjustments - deductions;

  /// إجمالي دقائق الحضور — أساس العائد للساعة.
  int get presenceMinutes => workedMinutes + overtimeMinutes;

  /// العائد الفعلي لكل ساعة حضور.
  ///
  /// الرقم الذي يقارن جهتين بعدل: الراتب الأكبر قد يقابله ضِعف الساعات.
  double get netPerHour =>
      presenceMinutes == 0 ? 0 : net / (presenceMinutes / 60);
}

/// دخل المستخدم من كل جهاته في فترة.
///
/// هذه أول قراءة تعبر الجهات: كل ما سواها مُرشَّح بجهة واحدة عمداً، وهذه
/// وحدها تجمع — لأن السؤال «كم دخلي هذا الشهر» لا معنى له داخل جهة واحدة.
class PersonalPayroll {
  const PersonalPayroll({
    required this.from,
    required this.to,
    required this.workplaces,
  });

  final DateTime from;
  final DateTime to;

  /// مرتّبة تنازلياً بالصافي — الأعلى دخلاً أولاً.
  final List<WorkplacePayroll> workplaces;

  double get totalBasic =>
      workplaces.fold(0.0, (sum, w) => sum + w.basic);

  double get totalOvertime =>
      workplaces.fold(0.0, (sum, w) => sum + w.overtime);

  double get totalDeductions =>
      workplaces.fold(0.0, (sum, w) => sum + w.deductions);

  double get totalAdjustments =>
      workplaces.fold(0.0, (sum, w) => sum + w.adjustments);

  /// إجمالي الدخل الشخصي من كل الجهات.
  double get totalNet => workplaces.fold(0.0, (sum, w) => sum + w.net);

  int get totalPresenceMinutes =>
      workplaces.fold(0, (sum, w) => sum + w.presenceMinutes);

  /// الجهة الأعلى دخلاً، أو null بلا جهات.
  WorkplacePayroll? get topEarner =>
      workplaces.isEmpty ? null : workplaces.first;

  /// الجهة الأعلى عائداً للساعة — قد تخالف الأعلى دخلاً، وهي المعلومة
  /// التي تُقرِّر أين يستحق الوقت أن يُنفَق.
  WorkplacePayroll? get bestHourlyReturn {
    if (workplaces.isEmpty) return null;
    return workplaces.reduce(
        (a, b) => b.netPerHour > a.netPerHour ? b : a);
  }
}
