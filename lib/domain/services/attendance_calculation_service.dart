import '../../core/utils/salary_calculator.dart';
import '../entities/company_entity.dart';
import '../entities/overtime_policy_entity.dart';
import '../entities/profile_entity.dart';

/// كل ما يُشتقّ من جلسات يوم واحد.
///
/// قيمٌ محضة بلا نموذج تخزين، فيمكن حسابها واختبارها بلا قاعدة بيانات.
class DayCalculation {
  const DayCalculation({
    required this.isOpen,
    required this.sessionCount,
    required this.firstCheckIn,
    required this.lastCheckOut,
    required this.isBiometricVerified,
    required this.requiredHours,
    required this.requiredMinutes,
    required this.presenceMinutes,
    required this.officialMinutes,
    required this.overtimeMinutes,
    required this.deficitMinutes,
    required this.overtimeValue,
    required this.deficitValue,
  });

  final bool isOpen;
  final int sessionCount;
  final DateTime? firstCheckIn;
  final DateTime? lastCheckOut;
  final bool isBiometricVerified;
  final int requiredHours;
  final int requiredMinutes;

  /// دقائق التواجد من الجلسات المغلقة وحدها.
  final int presenceMinutes;

  final int officialMinutes;
  final int overtimeMinutes;
  final int deficitMinutes;
  final double overtimeValue;
  final double deficitValue;
}

/// جلسة كما تصل إلى الحساب — بلا ارتباط بطبقة البيانات.
class SessionInput {
  const SessionInput({
    this.checkIn,
    this.checkOut,
    this.isBiometricVerified = false,
  });

  final DateTime? checkIn;
  final DateTime? checkOut;
  final bool isBiometricVerified;

  bool get isClosed => checkIn != null && checkOut != null;
  bool get isOpen => checkIn != null && checkOut == null;
}

/// يشتقّ أرقام اليوم من جلساته وشروط جهته.
///
/// كانت هذه الحسابات داخل `AttendanceRepositoryImpl._recalculate`، فالمستودع
/// يحمل الاستعلام والحساب المالي معاً ولا يُختبر أحدهما بمعزل عن الآخر.
/// هنا تصير دالة محضة: مدخلاتها جلسات وإعداد يوم، ومخرجها أرقام.
class AttendanceCalculationService {
  const AttendanceCalculationService();

  DayCalculation call({
    required List<SessionInput> sessions,
    required CompanyEntity company,
    required WorkDayConfigEntity dayConfig,
    required bool isAbsent,
    OvertimeDayType dayType = OvertimeDayType.normal,
  }) {
    final closed = sessions.where((s) => s.isClosed).toList();
    final isOpen = sessions.any((s) => s.isOpen);

    final presenceMinutes = closed.fold<int>(0, (sum, s) {
      final minutes = s.checkOut!.difference(s.checkIn!).inMinutes;
      return sum + (minutes < 0 ? 0 : minutes);
    });

    // الجلسة المفتوحة لا تدخل الحساب المالي حتى تُغلق: قيمتها غير نهائية.
    final calculator = SalaryCalculator(company);
    final details = calculator.calculateDayDetails(
      sessions: [
        for (final session in closed)
          SalaryCalculator.presence(session.checkIn!, session.checkOut!),
      ],
      scheduledStart: dayConfig.startTime,
      scheduledEnd: dayConfig.endTime,
      isCrossDay: dayConfig.isCrossDay,
      requiredHours: dayConfig.requiredHours,
      requiredMinutes: dayConfig.requiredMinutes,
    );

    final policy = company.policy;

    var deficitMinutes = details.deficitMinutes;
    // يوم بلا جلسات مغلقة ولا جلسة مفتوحة لا عجز عليه إلا إن أُعلن غياباً.
    if (closed.isEmpty && !isOpen && !isAbsent) deficitMinutes = 0;

    // السماح يُطبَّق على عجز اليوم كاملاً لا على التأخّر وحده: السجل يحفظ
    // الجلسات لا سبب النقص، فلا سبيل للتمييز بين من تأخّر عشر دقائق ومن
    // انصرف قبل الموعد بعشر. القاعدة معلنة صراحةً هنا كي لا تُفهم كسهو.
    if (deficitMinutes > 0 && deficitMinutes <= policy.graceMinutes) {
      deficitMinutes = 0;
    }

    // الدقائق تبقى كما هي في التقرير حتى حين لا تُدفع: أن يرى المستخدم أنه
    // عمل ساعتين إضافيتين بلا أجر معلومةٌ صحيحة، وإخفاؤها تزييف.
    var overtimeMinutes = details.overtimeMinutes;
    if (overtimeMinutes < policy.minOvertimeMinutes) overtimeMinutes = 0;
    final payableOvertimeMinutes = policy.paysOvertime ? overtimeMinutes : 0;

    return DayCalculation(
      isOpen: isOpen,
      sessionCount: closed.length,
      firstCheckIn: sessions.isEmpty ? null : sessions.first.checkIn,
      lastCheckOut:
          isOpen || sessions.isEmpty ? null : sessions.last.checkOut,
      isBiometricVerified:
          sessions.isNotEmpty && sessions.every((s) => s.isBiometricVerified),
      requiredHours: dayConfig.requiredHours,
      requiredMinutes: dayConfig.requiredMinutes,
      presenceMinutes: presenceMinutes,
      officialMinutes: details.officialMinutes,
      overtimeMinutes: overtimeMinutes,
      deficitMinutes: deficitMinutes,
      overtimeValue: calculator.calculateOvertimeValue(
          payableOvertimeMinutes ~/ 60, payableOvertimeMinutes % 60,
          dayType: dayType),
      deficitValue: calculator.calculateDeficitValue(
          deficitMinutes ~/ 60, deficitMinutes % 60),
    );
  }
}
