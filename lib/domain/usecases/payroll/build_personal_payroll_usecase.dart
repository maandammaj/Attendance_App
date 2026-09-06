import '../../../core/utils/salary_calculator.dart';
import '../../entities/company_entity.dart';
import '../../entities/payroll_entity.dart';
import '../../repositories/attendance_repository.dart';

/// يبني دخل المستخدم من كل جهاته في فترة واحدة.
///
/// كل جهة تُقرأ بشروطها هي — راتبها وبدلاتها وأجر إضافيها — ثم تُجمع
/// النواتج. الجمع يقع على المال وحده: الساعات والأيام تبقى مفصّلة، لأن
/// «184 ساعة» عبر جهتين رقم لا يقود إلى قرار.
class BuildPersonalPayrollUseCase {
  const BuildPersonalPayrollUseCase(this.attendanceRepository);

  final AttendanceRepository attendanceRepository;

  Future<PersonalPayroll> call({
    required List<CompanyEntity> companies,
    required DateTime from,
    required DateTime to,
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

      for (final record in records) {
        workedMinutes += (record.workedHours * 60) + record.workedMinutes;
        overtimeMinutes += (record.overtimeHours * 60) + record.overtimeMinutes;
        overtimeValue += record.overtimeValue;
        deficitValue += record.deficitValue;
        if (record.sessions.isNotEmpty) attendedDays++;
      }

      // البدلات تُقرأ من الحاسبة لا تُجمع هنا: هي شرط من شروط الجهة،
      // وحسابها في موضعين يفتح باب اختلافهما.
      final monthly = SalaryCalculator(company).calculateMonthly(
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
      ));
    }

    results.sort((a, b) => b.net.compareTo(a.net));
    return PersonalPayroll(from: from, to: to, workplaces: results);
  }
}
