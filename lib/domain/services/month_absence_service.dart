import '../../core/utils/clock.dart';
import '../../core/utils/date_helpers.dart';
import '../entities/attendance_entity.dart';
import '../entities/calendar_day_entity.dart';
import '../entities/company_entity.dart';
import '../entities/leave_entity.dart';
import '../entities/profile_entity.dart';
import 'effective_day_resolver.dart';

/// أيام الشهر التي مضت ولم يُسجَّل فيها حضور.
class MonthAbsence {
  const MonthAbsence({
    required this.expectedWorkingDays,
    required this.requiredMinutes,
    required this.absentMinutes,
  });

  final int expectedWorkingDays;
  final int requiredMinutes;

  /// دقائق أيام العمل التي مرّت بلا سجل يفسّرها.
  final int absentMinutes;
}

/// يحسب غياب الشهر من الجدول والتقويم والإجازات.
///
/// مستقلٌّ عن الإحصاءات والرواتب لأن كليهما يحتاجه: شاشة الدوام كانت تخصم
/// الغياب وشاشة الدخل لا، فتعرض الأولى «عليك 462» وتعرض الثانية الراتب
/// كاملاً عن الشهر نفسه. نسختان من القاعدة تعنيان رقمين متخالفين.
class MonthAbsenceService {
  const MonthAbsenceService({this.clock = const SystemClock()});

  final Clock clock;

  MonthAbsence call({
    required int year,
    required int month,
    required CompanyEntity company,
    required List<AttendanceEntity> records,
    List<CalendarDayEntity> calendar = const [],
    List<LeaveEntity> leaves = const [],
  }) {
    final now = clock.now();

    // آخر يوم يُحاسَب عليه. الشهر القادم لم يُطلَب منه شيء بعد، فحسابه
    // كاملاً غياباً التزامٌ مُختلَق عن أيام لم تأتِ.
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final isCurrentMonth = year == now.year && month == now.month;
    final isFuture =
        DateTime(year, month).isAfter(DateTime(now.year, now.month));
    final endDay = isFuture
        ? 0
        : isCurrentMonth
            ? now.day - 1
            : daysInMonth;

    var expectedWorkingDays = 0;
    var requiredMinutes = 0;
    var absentMinutes = 0;

    for (var day = 1; day <= endDay; day++) {
      final date = DateTime(year, month, day);
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

    return MonthAbsence(
      expectedWorkingDays: expectedWorkingDays,
      requiredMinutes: requiredMinutes,
      absentMinutes: absentMinutes,
    );
  }
}
