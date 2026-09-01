import '../../../core/utils/date_helpers.dart';
import '../../../core/utils/salary_calculator.dart';
import '../../entities/company_entity.dart';
import '../../entities/profile_entity.dart';
import '../../repositories/attendance_repository.dart';

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
  GetMonthlyStatsUseCase(this.repository);

  Future<MonthlyStats> call(int year, int month, CompanyEntity company) async {
    final records = await repository.getMonthlyRecords(year, month);
    final now = DateTime.now();
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
      }
    }

    // 2. حساب الغياب التلقائي (الأيام التي مرت ولم يحضر فيها)
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final endDay = (year == now.year && month == now.month) ? now.day - 1 : daysInMonth;

    for (int day = 1; day <= endDay; day++) {
      final date = DateTime(year, month, day);
      final dayOfWeek = DateHelpers.scheduleDayOf(date);
      
      final dayConfig = company.workSchedule.firstWhere(
        (d) => d.dayOfWeek == dayOfWeek,
        orElse: () => WorkDayConfigEntity(
          dayOfWeek: dayOfWeek,
          isWorkingDay: false,
          requiredHours: 0,
          requiredMinutes: 0,
          isHoliday: true,
        ),
      );

      if (dayConfig.isWorkingDay && !dayConfig.isHoliday) {
        expectedWorkingDays++;
        totalRequiredMinutes +=
            (dayConfig.requiredHours * 60) + dayConfig.requiredMinutes;
        
        final hasRecord = records.any((r) => DateHelpers.isSameDay(r.date, date));
        if (!hasRecord) {
          final missingMinutes = (dayConfig.requiredHours * 60) + dayConfig.requiredMinutes;
          totalAbsenceMinutes += missingMinutes;
          
          totalDeficitValue += calculator.calculateDeficitValue(
              missingMinutes ~/ 60, missingMinutes % 60);
        }
      }
    }

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
