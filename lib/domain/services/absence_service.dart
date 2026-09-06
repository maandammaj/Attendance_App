import '../../core/utils/clock.dart';
import '../../core/utils/date_helpers.dart';
import '../entities/attendance_entity.dart';
import '../entities/calendar_day_entity.dart';
import '../entities/company_entity.dart';
import '../entities/leave_entity.dart';
import '../entities/profile_entity.dart';
import 'effective_day_resolver.dart';

/// أيام الفترة التي مضت ولم يُسجَّل فيها حضور.
class Absence {
  const Absence({
    required this.expectedWorkingDays,
    required this.requiredMinutes,
    required this.absentMinutes,
  });

  final int expectedWorkingDays;
  final int requiredMinutes;

  /// دقائق أيام العمل التي مرّت بلا سجل يفسّرها.
  final int absentMinutes;
}

/// يحسب الغياب في فترة من الجدول والتقويم والإجازات.
///
/// مستقلٌّ عن الإحصاءات والرواتب لأن كليهما يحتاجه: شاشة الدوام كانت تخصم
/// الغياب وشاشة الدخل لا، فتعرض الأولى «عليك 462» وتعرض الثانية الراتب
/// كاملاً عن الشهر نفسه. نسختان من القاعدة تعنيان رقمين متخالفين.
class AbsenceService {
  const AbsenceService({this.clock = const SystemClock()});

  final Clock clock;

  Absence call({
    required DateTime from,
    required DateTime to,
    required CompanyEntity company,
    required List<AttendanceEntity> records,
    List<CalendarDayEntity> calendar = const [],
    List<LeaveEntity> leaves = const [],
  }) {
    // آخر يوم يُحاسَب عليه هو أمس: اليوم الجاري لم ينتهِ بعد، وما بعده لم
    // يُطلَب منه شيء أصلاً — فحسابه غياباً التزامٌ مُختلَق عن أيام لم تأتِ.
    final yesterday =
        DateHelpers.startOfDay(clock.now()).subtract(const Duration(days: 1));
    final requestedEnd = DateHelpers.startOfDay(to);
    final end = yesterday.isBefore(requestedEnd) ? yesterday : requestedEnd;

    var expectedWorkingDays = 0;
    var requiredMinutes = 0;
    var absentMinutes = 0;

    for (var date = DateHelpers.startOfDay(from);
        !date.isAfter(end);
        date = date.add(const Duration(days: 1))) {
      final dayOfWeek = DateHelpers.scheduleDayOf(date);

      final scheduled = company.workSchedule.firstWhere(
        (d) => d.dayOfWeek == dayOfWeek,
        orElse: () => WorkDayConfigEntity(
          dayOfWeek: dayOfWeek,
          isWorkingDay: false,
          requiredHours: 0,
          requiredMinutes: 0,
          isHoliday: true,
        ),
      );

      // التقويم يغلب الجدول، والإجازة المدفوعة تُفرِّغ المطلوب.
      final dayConfig = EffectiveDayResolver.apply(
        base: scheduled,
        entry: EffectiveDayResolver.governing(
          calendar.where((e) => DateHelpers.isSameDay(e.date, date)).toList(),
          company.id,
        ),
        leave: EffectiveDayResolver.leaveOn(leaves, date),
      );

      if (!dayConfig.isWorkingDay || dayConfig.isHoliday) continue;

      expectedWorkingDays++;
      requiredMinutes += dayConfig.requiredMinutesTotal;

      // سجل فارغ غير معلن غياباً لا يفسّر اليوم، فيبقى غياباً تلقائياً.
      final explained = records.any((r) =>
          DateHelpers.isSameDay(r.date, date) &&
          (r.sessions.isNotEmpty || r.isAbsent));
      if (!explained) absentMinutes += dayConfig.requiredMinutesTotal;
    }

    return Absence(
      expectedWorkingDays: expectedWorkingDays,
      requiredMinutes: requiredMinutes,
      absentMinutes: absentMinutes,
    );
  }
}
