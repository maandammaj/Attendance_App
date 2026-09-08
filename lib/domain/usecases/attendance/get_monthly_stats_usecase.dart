import '../../../core/utils/clock.dart';
import '../../../core/utils/salary_calculator.dart';
import '../../entities/calendar_day_entity.dart';
import '../../entities/company_entity.dart';
import '../../entities/leave_entity.dart';
import '../../repositories/attendance_repository.dart';
import '../../services/absence_service.dart';

class MonthlyStats {
  final int expectedWorkingDays;
  final int actualWorkingDays;
  final int absentDays;

  /// إجمالي الساعات المطلوبة بحسب جدول الدوام لأيام العمل التي مضت.
  final double totalRequiredHours;

  /// إجمالي الساعات المحتسبة رسمياً (داخل نافذة الوردية إن وُجدت).
  final double totalWorkedHours;

  /// إجمالي دقائق التواجد الفعلي شاملةً ما وقع خارج النافذة.
  final double totalPresenceHours;

  final double totalOvertimeHours;
  final double totalLatenessHours;
  final double totalAbsenceHours;
  final double totalOvertimeValue;
  final double totalDeficitValue; // Total financial penalty (lateness + absence)
  final double netExtraValue;

  /// نسبة الإنجاز مقابل المطلوب — مقياس واحد يلخّص الشهر.
  double get completionRate =>
      totalRequiredHours <= 0 ? 0 : totalWorkedHours / totalRequiredHours;

  MonthlyStats({
    required this.expectedWorkingDays,
    required this.actualWorkingDays,
    required this.absentDays,
    this.totalRequiredHours = 0,
    this.totalWorkedHours = 0,
    this.totalPresenceHours = 0,
    required this.totalOvertimeHours,
    required this.totalLatenessHours,
    required this.totalAbsenceHours,
    required this.totalOvertimeValue,
    required this.totalDeficitValue,
    required this.netExtraValue,
  });
}

class GetMonthlyStatsUseCase {
  final AttendanceRepository repository;

  /// الساعة مُدخَل صريح: «كم يوماً مضى من الشهر» يقرَّر منها، فهي جزء من
  /// الحساب لا تفصيل تشغيلي.
  final Clock clock;

  GetMonthlyStatsUseCase(this.repository, {this.clock = const SystemClock()});

  Future<MonthlyStats> call(
    int year,
    int month,
    CompanyEntity company, {
    List<CalendarDayEntity> calendar = const [],
    List<LeaveEntity> leaves = const [],
  }) async {
    final records = await repository.getMonthlyRecords(year, month);
    final calculator = SalaryCalculator(company);

    int totalOvertimeMinutes = 0;
    int totalRequiredMinutes = 0;
    int totalWorkedMinutes = 0;
    int totalPresenceMinutes = 0;
    int totalLatenessMinutes = 0;
    int totalAbsenceMinutes = 0;
    double totalOvertimeValue = 0;
    double totalDeficitValue = 0;
    int actualWorkingDays = 0;
    int expectedWorkingDays = 0;

    // 1. حساب الإحصائيات من السجلات الفعلية (الحاضرين)
    for (final record in records) {
      if (record.sessions.isNotEmpty) {
        actualWorkingDays++;
        totalWorkedMinutes += (record.workedHours * 60) + record.workedMinutes;
        totalPresenceMinutes += record.totalPresenceMinutes;
        totalOvertimeMinutes += (record.overtimeHours * 60) + record.overtimeMinutes;
        totalLatenessMinutes += (record.deficitHours * 60) + record.deficitMinutes;
        totalOvertimeValue += record.overtimeValue;
        totalDeficitValue += record.deficitValue;
      } else if (record.isAbsent) {
        // غياب معلن صراحةً. بدون هذا الفرع كان يسقط من الحسابين معاً: الأول
        // يتخطّاه لأنه بلا جلسات، والثاني لأن لليوم سجلاً — فيخرج إعلان
        // الغياب أرخص من تركه فارغاً، وهو عكس المقصود تماماً.
        totalAbsenceMinutes += record.requiredMinutesTotal;
        totalDeficitValue += record.deficitValue;
      }
    }

    // 2. الغياب التلقائي — قاعدة واحدة تقرأها هذه الشاشة وشاشة الدخل معاً.
    final absence = AbsenceService(clock: clock)(
      from: DateTime(year, month, 1),
      to: DateTime(year, month + 1, 0),
      company: company,
      records: records,
      calendar: calendar,
      leaves: leaves,
    );

    expectedWorkingDays = absence.expectedWorkingDays;
    totalRequiredMinutes = absence.requiredMinutes;
    totalAbsenceMinutes += absence.absentMinutes;
    totalDeficitValue += calculator.calculateDeficitValue(
        absence.absentMinutes ~/ 60, absence.absentMinutes % 60);

    return MonthlyStats(
      expectedWorkingDays: expectedWorkingDays,
      actualWorkingDays: actualWorkingDays,
      absentDays: expectedWorkingDays - actualWorkingDays > 0 ? expectedWorkingDays - actualWorkingDays : 0,
      totalRequiredHours: totalRequiredMinutes / 60,
      totalWorkedHours: totalWorkedMinutes / 60,
      totalPresenceHours: totalPresenceMinutes / 60,
      totalOvertimeHours: totalOvertimeMinutes / 60,
      totalLatenessHours: totalLatenessMinutes / 60,
      totalAbsenceHours: totalAbsenceMinutes / 60,
      totalOvertimeValue: totalOvertimeValue,
      totalDeficitValue: totalDeficitValue,
      netExtraValue: totalOvertimeValue - totalDeficitValue,
    );
  }
}
