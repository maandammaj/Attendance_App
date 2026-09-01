import '../../../core/utils/date_helpers.dart';
import '../../entities/attendance_entity.dart';
import '../../entities/profile_entity.dart';
import '../../repositories/attendance_repository.dart';

class MonthlyStats {
  final int expectedWorkingDays;
  final int actualWorkingDays;
  final int absentDays;
  final double totalOvertimeHours;
  final double totalLatenessHours;
  final double totalAbsenceHours;
  final double totalOvertimeValue;
  final double totalDeficitValue; // Total financial penalty (lateness + absence)
  final double netExtraValue;

  MonthlyStats({
    required this.expectedWorkingDays,
    required this.actualWorkingDays,
    required this.absentDays,
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

  Future<MonthlyStats> call(int year, int month, ProfileEntity profile) async {
    final records = await repository.getMonthlyRecords(year, month);
    final now = DateTime.now();

    int totalOvertimeMinutes = 0;
    int totalLatenessMinutes = 0;
    int totalAbsenceMinutes = 0;
    double totalOvertimeValue = 0;
    double totalDeficitValue = 0;
    int actualWorkingDays = 0;
    int expectedWorkingDays = 0;

    // 1. حساب الإحصائيات من السجلات الفعلية (الحاضرين)
    for (final record in records) {
      if (record.checkIn != null) {
        actualWorkingDays++;
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
      final dayOfWeek = date.weekday % 7;
      
      final dayConfig = profile.workSchedule.firstWhere(
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
        
        final hasRecord = records.any((r) => DateHelpers.isSameDay(r.date, date));
        if (!hasRecord) {
          final missingMinutes = (dayConfig.requiredHours * 60) + dayConfig.requiredMinutes;
          totalAbsenceMinutes += missingMinutes;
          
          final hourlyRate = profile.hourlyRate > 0 
              ? profile.hourlyRate 
              : (profile.baseMonthlySalary / 160); // افتراض 160 ساعة عمل شهرية
              
          totalDeficitValue += (missingMinutes / 60) * hourlyRate;
        }
      }
    }

    return MonthlyStats(
      expectedWorkingDays: expectedWorkingDays,
      actualWorkingDays: actualWorkingDays,
      absentDays: expectedWorkingDays - actualWorkingDays > 0 ? expectedWorkingDays - actualWorkingDays : 0,
      totalOvertimeHours: totalOvertimeMinutes / 60,
      totalLatenessHours: totalLatenessMinutes / 60,
      totalAbsenceHours: totalAbsenceMinutes / 60,
      totalOvertimeValue: totalOvertimeValue,
      totalDeficitValue: totalDeficitValue,
      netExtraValue: totalOvertimeValue - totalDeficitValue,
    );
  }
}
