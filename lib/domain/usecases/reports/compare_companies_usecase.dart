import '../../../core/utils/salary_calculator.dart';
import '../../entities/analytics_report_entity.dart';
import '../../entities/company_entity.dart';
import '../../repositories/attendance_repository.dart';

/// أداء جهة واحدة خلال فترة، بصيغة تسمح بمقارنتها بغيرها.
class CompanyPerformance {
  const CompanyPerformance({
    required this.company,
    required this.workedMinutes,
    required this.overtimeMinutes,
    required this.deficitMinutes,
    required this.attendedDays,
    required this.earned,
  });

  final CompanyEntity company;
  final int workedMinutes;
  final int overtimeMinutes;
  final int deficitMinutes;
  final int attendedDays;

  /// المستحق من هذه الجهة: الأساسي زائد الإضافي ناقص العجز.
  final double earned;

  int get presenceMinutes => workedMinutes + overtimeMinutes;

  /// العائد الفعلي لكل ساعة حضور — الرقم الوحيد الذي يقارن جهتين بعدل،
  /// فالراتب الأكبر قد يقابله ضِعف الساعات.
  double get effectiveHourlyRate =>
      presenceMinutes == 0 ? 0 : earned / (presenceMinutes / 60);
}

/// يبني أداء كل جهة خلال نفس الفترة.
///
/// المقارنة هي السبب الرئيسي لتعدّد الجهات: أيّها يستحق وقتك أكثر.
class CompareCompaniesUseCase {
  CompareCompaniesUseCase(this.attendanceRepository);

  final AttendanceRepository attendanceRepository;

  Future<List<CompanyPerformance>> call({
    required List<CompanyEntity> companies,
    required ReportPeriod period,
  }) async {
    final results = <CompanyPerformance>[];

    for (final company in companies) {
      final records = await attendanceRepository.getRecordsForCompany(
        company.id,
        period.from,
        period.to,
      );

      var worked = 0;
      var overtime = 0;
      var deficit = 0;
      var attended = 0;
      var overtimeValue = 0.0;
      var deficitValue = 0.0;

      for (final record in records) {
        worked += (record.workedHours * 60) + record.workedMinutes;
        overtime += (record.overtimeHours * 60) + record.overtimeMinutes;
        deficit += (record.deficitHours * 60) + record.deficitMinutes;
        overtimeValue += record.overtimeValue;
        deficitValue += record.deficitValue;
        if (record.sessions.isNotEmpty) attended++;
      }

      final monthly = SalaryCalculator(company).calculateMonthly(
        totalOvertimeValue: overtimeValue,
        totalDeficitValue: deficitValue,
        totalDebtPayments: 0,
        totalTransactionsExpenses: 0,
      );

      results.add(CompanyPerformance(
        company: company,
        workedMinutes: worked,
        overtimeMinutes: overtime,
        deficitMinutes: deficit,
        attendedDays: attended,
        earned: monthly.gross,
      ));
    }

    // الأعلى عائداً للساعة أولاً: هذا ترتيب الإجابة على السؤال المطروح.
    results.sort(
        (a, b) => b.effectiveHourlyRate.compareTo(a.effectiveHourlyRate));
    return results;
  }
}
