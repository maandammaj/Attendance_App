import '../../../core/utils/salary_calculator.dart';
import '../../entities/company_entity.dart';
import '../../entities/payroll_entity.dart';
import '../../entities/calendar_day_entity.dart';
import '../../entities/leave_entity.dart';
import '../../repositories/attendance_repository.dart';
import '../../services/absence_service.dart';

/// يبني دخل المستخدم من كل جهاته في فترة واحدة.
///
/// كل جهة تُقرأ بشروطها هي — راتبها وبدلاتها وأجر إضافيها — ثم تُجمع
/// النواتج. الجمع يقع على المال وحده: الساعات والأيام تبقى مفصّلة، لأن
/// «184 ساعة» عبر جهتين رقم لا يقود إلى قرار.
class BuildPersonalPayrollUseCase {
  const BuildPersonalPayrollUseCase(
    this.attendanceRepository, {
    this.absenceService = const AbsenceService(),
  });

  final AttendanceRepository attendanceRepository;

  /// القاعدة نفسها التي تستعملها شاشة الدوام — لا نسخة ثانية منها.
  final AbsenceService absenceService;

  Future<PersonalPayroll> call({
    required List<CompanyEntity> companies,
    required DateTime from,
    required DateTime to,
    List<LeaveEntity> leaves = const [],
    List<CalendarDayEntity> calendar = const [],
  }) async {
    final results = <WorkplacePayroll>[];

    for (final company in companies) {
      final records =
          await attendanceRepository.getRecordsForCompany(company.id, from, to);

      var workedMinutes = 0;
      var overtimeMinutes = 0;
      var overtimeValue = 0.0;
      var deficitValue = 0.0;
      var attendedDays = 0;
      var holidayOvertime = 0;

      for (final record in records) {
        // التصنيف من السجل نفسه: يُحدَّث مع كل إعادة حساب فيتبع التقويم.
        if (record.dayType == 'holiday' || record.dayType == 'friday') {
          holidayOvertime +=
              (record.overtimeHours * 60) + record.overtimeMinutes;
        }
        workedMinutes += (record.workedHours * 60) + record.workedMinutes;
        overtimeMinutes += (record.overtimeHours * 60) + record.overtimeMinutes;
        overtimeValue += record.overtimeValue;
        deficitValue += record.deficitValue;
        if (record.sessions.isNotEmpty) attendedDays++;
      }

      // أيام مضت بلا سجل يفسّرها تُخصم أيضاً. جمعُ السجلات وحدها كان يُظهر
      // الراتب كاملاً في هذه الشاشة بينما تخصمه شاشة الدوام — رقمان
      // متخالفان عن الشهر نفسه، والأعلى منهما هو الخاطئ.
      final calculator = SalaryCalculator(company);
      final absence = absenceService(
        from: from,
        to: to,
        company: company,
        records: records,
        calendar: calendar,
        leaves: leaves,
      );
      deficitValue += calculator.calculateDeficitValue(
          absence.absentMinutes ~/ 60, absence.absentMinutes % 60);

      // البدلات تُقرأ من الحاسبة لا تُجمع هنا: هي شرط من شروط الجهة،
      // وحسابها في موضعين يفتح باب اختلافهما.
      final monthly = calculator.calculateMonthly(
        totalOvertimeValue: overtimeValue,
        totalDeficitValue: deficitValue,
        totalDebtPayments: 0,
        totalTransactionsExpenses: 0,
      );

      results.add(WorkplacePayroll(
        company: company,
        basic: company.baseMonthlySalary,
        overtime: overtimeValue,
        deductions: deficitValue,
        adjustments: monthly.adjustments,
        workedMinutes: workedMinutes,
        overtimeMinutes: overtimeMinutes,
        attendedDays: attendedDays,
        leaveDays: _leaveDaysIn(leaves, company.id, from, to),
        holidayOvertimeMinutes: holidayOvertime,
      ));
    }

    results.sort((a, b) => b.net.compareTo(a.net));
    return PersonalPayroll(from: from, to: to, workplaces: results);
  }

  /// أيام الإجازة الواقعة داخل الفترة، مقصوصة على حدّيها.
  static int _leaveDaysIn(
    List<LeaveEntity> leaves,
    int companyId,
    DateTime from,
    DateTime to,
  ) {
    var days = 0;
    for (final leave in leaves) {
      if (leave.companyId != companyId) continue;
      final start = leave.from.isBefore(from) ? from : leave.from;
      final end = leave.to.isAfter(to) ? to : leave.to;
      final span = end.difference(start).inDays + 1;
      if (span > 0) days += span;
    }
    return days;
  }
}
