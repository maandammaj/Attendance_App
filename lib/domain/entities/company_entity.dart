import '../../core/utils/date_helpers.dart';
import 'leave_entity.dart';
import 'overtime_policy_entity.dart';
import 'profile_entity.dart';

/// جهة عمل بشروطها. كل حساب راتب أو تقرير يجري على واحدة منها.
class CompanyEntity {
  final int id;
  final String name;
  final String jobTitle;
  final double baseMonthlySalary;
  final double hourlyRate;
  final double overtimeRate;
  final List<WorkDayConfigEntity> workSchedule;

  /// قواعد هذه الجهة. غيابها يعني الافتراضي المحايد.
  final WorkPolicyEntity policy;

  /// أجور الإضافي إن حُدِّدت صراحةً. الوصول إليها من [overtimePolicy].
  final OvertimePolicyEntity? explicitOvertimePolicy;

  /// أرصدة الإجازات المُعلَنة لهذه الجهة.
  final List<LeaveAllowanceEntity> leaveAllowances;
  final List<SalaryAdjustmentEntity> adjustments;
  final String? currency;
  final DateTime? employmentStartDate;
  final int colorIndex;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CompanyEntity({
    required this.id,
    required this.name,
    required this.jobTitle,
    required this.baseMonthlySalary,
    required this.hourlyRate,
    required this.overtimeRate,
    required this.workSchedule,
    this.policy = const WorkPolicyEntity(),
    this.explicitOvertimePolicy,
    this.leaveAllowances = const [],
    required this.adjustments,
    this.currency,
    this.employmentStartDate,
    this.colorIndex = 0,
    this.isArchived = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// أجور الإضافي المطبَّقة فعلاً.
  ///
  /// السياسة الصريحة إن وُجدت، وإلا فمشتقّة من [overtimeRate] بالقاعدة
  /// القديمة نفسها — فجهة لم تُحدَّد لها سياسة تحسب كما كانت تماماً.
  OvertimePolicyEntity get overtimePolicy =>
      explicitOvertimePolicy ??
      OvertimePolicyEntity.fromLegacyRate(overtimeRate);

  /// إعداد الجدول ليوم بعينه.
  ///
  /// القاعدة الوحيدة: يُبحث بـ [DateHelpers.scheduleDayOf] لا بـ
  /// `weekday % 7` — الثاني يُسقط الأحد على 0 فلا يطابق أي إعداد مخزَّن.
  /// المستودع والواجهة يقرآن من هنا، فلا ينشأ جدولان متخالفان.
  WorkDayConfigEntity configFor(DateTime date) {
    final scheduleDay = DateHelpers.scheduleDayOf(date);
    return workSchedule.firstWhere(
      (day) => day.dayOfWeek == scheduleDay,
      orElse: () => WorkDayConfigEntity(
        dayOfWeek: scheduleDay,
        isWorkingDay: true,
        requiredHours: 8,
        requiredMinutes: 0,
        isHoliday: false,
      ),
    );
  }

  /// إجمالي الساعات المطلوبة أسبوعياً — يظهر في بطاقة الجهة وشاشة الجدول.
  double get weeklyHours => workSchedule
      .where((day) => day.isWorkingDay && !day.isHoliday)
      .fold(0.0, (sum, day) => sum + day.requiredHours + day.requiredMinutes / 60);

  CompanyEntity copyWith({
    String? name,
    String? jobTitle,
    double? baseMonthlySalary,
    double? hourlyRate,
    double? overtimeRate,
    List<WorkDayConfigEntity>? workSchedule,
    WorkPolicyEntity? policy,
    OvertimePolicyEntity? explicitOvertimePolicy,
    List<LeaveAllowanceEntity>? leaveAllowances,
    List<SalaryAdjustmentEntity>? adjustments,
    String? currency,
    DateTime? employmentStartDate,
    int? colorIndex,
    bool? isArchived,
  }) {
    return CompanyEntity(
      id: id,
      name: name ?? this.name,
      jobTitle: jobTitle ?? this.jobTitle,
      baseMonthlySalary: baseMonthlySalary ?? this.baseMonthlySalary,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      overtimeRate: overtimeRate ?? this.overtimeRate,
      workSchedule: workSchedule ?? this.workSchedule,
      policy: policy ?? this.policy,
      explicitOvertimePolicy:
          explicitOvertimePolicy ?? this.explicitOvertimePolicy,
      leaveAllowances: leaveAllowances ?? this.leaveAllowances,
      adjustments: adjustments ?? this.adjustments,
      currency: currency ?? this.currency,
      employmentStartDate: employmentStartDate ?? this.employmentStartDate,
      colorIndex: colorIndex ?? this.colorIndex,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
