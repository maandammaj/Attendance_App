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
    this.leaveDays = 0,
    this.holidayOvertimeMinutes = 0,
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

  /// أيام الإجازة المأخوذة من هذه الجهة في الفترة.
  final int leaveDays;

  /// الإضافي الواقع في عطلة أو يوم راحة — يُفصل لأنه يُدفع بمعدّل آخر،
  /// فجمعه مع إضافي أيام العمل يخفي من أين جاء المال.
  final int holidayOvertimeMinutes;

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

  int get totalWorkedMinutes =>
      workplaces.fold(0, (sum, w) => sum + w.workedMinutes);

  int get totalOvertimeMinutes =>
      workplaces.fold(0, (sum, w) => sum + w.overtimeMinutes);

  /// أيام الإجازة عبر كل الجهات.
  ///
  /// تُجمع لأن الإجازة وقت المستخدم لا وقت الجهة: يومٌ أُخذ من جهة هو يوم
  /// من عمره. الأرصدة تبقى مفصّلة، وهذا العدد للاطّلاع لا للمحاسبة.
  int get totalLeaveDays =>
      workplaces.fold(0, (sum, w) => sum + w.leaveDays);

  int get totalPresenceMinutes =>
      workplaces.fold(0, (sum, w) => sum + w.presenceMinutes);

  /// عملات الجهات كلها إن اتفقت، وإلا null.
  ///
  /// جمعُ عملتين مختلفتين في رقم واحد لا معنى له: «128,500» من ريال ودولار
  /// ليست مبلغاً. فحين تختلف، يُعرض تفصيل كل جهة بعملتها ولا يُعرض إجمالي.
  String? get sharedCurrency {
    if (workplaces.isEmpty) return null;
    final first = workplaces.first.company.currency;
    for (final workplace in workplaces) {
      if (workplace.company.currency != first) return null;
    }
    return first;
  }

  /// هل يصحّ جمع دخل الجهات في رقم واحد.
  bool get hasComparableTotal => workplaces.length < 2 || sharedCurrency != null;

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
