import '../../entities/leave_entity.dart';
import '../../entities/payroll_entity.dart';
import '../../entities/personal_insight_entity.dart';

/// يقارن شهراً بالذي قبله ويستخرج ما يستحق أن يُقال.
///
/// القاعدة الحاكمة: **لا تتكلّم إلا عن فرق مادّي**. رؤيةٌ تنطلق على ضجيج
/// أسوأ من لا رؤية — تعلّم المستخدم تجاهل الشاشة. لذلك لكل قاعدة عتبتان:
/// نسبة وحدّ أدنى مطلق، وكلتاهما تلزم.
class BuildPersonalInsightsUseCase {
  const BuildPersonalInsightsUseCase();

  /// أقلّ تغيّر نسبي يستحق الذكر.
  static const _minRatio = 0.05;

  /// أقلّ تغيّر في الإضافي يستحق الذكر — نصف ساعة.
  static const _minOvertimeMinutes = 30;

  List<PersonalInsight> call({
    required PersonalPayroll current,
    PersonalPayroll? previous,
    List<LeaveBalanceEntity> leaveBalances = const [],
  }) {
    final insights = <PersonalInsight>[];

    insights.addAll(_incomeChange(current, previous));
    insights.addAll(_perWorkplaceChange(current, previous));
    final overtime = _overtimeTrend(current, previous);
    if (overtime != null) insights.add(overtime);
    final divergence = _hourlyDivergence(current);
    if (divergence != null) insights.add(divergence);
    insights.addAll(_leaveUsage(leaveBalances));

    return insights;
  }

  /// تغيّر الدخل الكلي.
  List<PersonalInsight> _incomeChange(
      PersonalPayroll current, PersonalPayroll? previous) {
    if (previous == null) return const [];

    // أساس صفري لا يُقارَن به: «زاد ما لا نهاية بالمئة» ليس معلومة.
    final before = previous.totalNet;
    if (before <= 0) return const [];

    final ratio = (current.totalNet - before) / before;
    if (ratio.abs() < _minRatio) return const [];

    final percent = (ratio.abs() * 100).round();
    return [
      PersonalInsight(
        message: ratio > 0
            ? 'دخلك هذا الشهر أعلى بـ$percent٪ عن الشهر الماضي'
            : 'دخلك هذا الشهر أقلّ بـ$percent٪ عن الشهر الماضي',
        tone: ratio > 0 ? InsightTone.positive : InsightTone.negative,
      ),
    ];
  }

  /// تغيّر الدخل من جهة بعينها — الجهة الأكبر تغيّراً وحدها.
  ///
  /// واحدة لا كلّها: سردُ كل جهة يحوّل الرؤى إلى جدول، والجدول موجود أصلاً
  /// في شاشة الدخل.
  List<PersonalInsight> _perWorkplaceChange(
      PersonalPayroll current, PersonalPayroll? previous) {
    if (previous == null) return const [];

    ({String name, double ratio})? biggest;

    for (final workplace in current.workplaces) {
      final before = previous.workplaces
          .where((w) => w.company.id == workplace.company.id)
          .firstOrNull;
      if (before == null || before.net <= 0) continue;

      final ratio = (workplace.net - before.net) / before.net;
      if (ratio.abs() < _minRatio) continue;
      if (biggest == null || ratio.abs() > biggest.ratio.abs()) {
        biggest = (name: workplace.company.name, ratio: ratio);
      }
    }

    if (biggest == null) return const [];
    final percent = (biggest.ratio.abs() * 100).round();
    return [
      PersonalInsight(
        message: biggest.ratio > 0
            ? 'دخلك من «${biggest.name}» أعلى بـ$percent٪ هذا الشهر'
            : 'دخلك من «${biggest.name}» أقلّ بـ$percent٪ هذا الشهر',
        tone:
            biggest.ratio > 0 ? InsightTone.positive : InsightTone.negative,
      ),
    ];
  }

  PersonalInsight? _overtimeTrend(
      PersonalPayroll current, PersonalPayroll? previous) {
    if (previous == null) return null;

    final delta = current.totalOvertimeMinutes - previous.totalOvertimeMinutes;
    if (delta.abs() < _minOvertimeMinutes) return null;

    final hours = (delta.abs() / 60).toStringAsFixed(1);
    return PersonalInsight(
      message: delta > 0
          ? 'إضافيك زاد $hours ساعة عن الشهر الماضي'
          : 'إضافيك نقص $hours ساعة عن الشهر الماضي',
      // زيادة الإضافي ليست خبراً ساراً بالضرورة: مالٌ أكثر ووقتٌ أقلّ.
      tone: InsightTone.neutral,
    );
  }

  /// حين تخالف الجهة الأعلى دخلاً الجهةَ الأعلى عائداً للساعة.
  ///
  /// هذه أنفع رؤية في الشاشة: الصافي وحده يقول أين المال، وهذه تقول أين
  /// يستحق الوقت أن يُنفَق.
  PersonalInsight? _hourlyDivergence(PersonalPayroll current) {
    if (current.workplaces.length < 2) return null;

    final top = current.topEarner;
    final best = current.bestHourlyReturn;
    if (top == null || best == null) return null;
    if (top.company.id == best.company.id) return null;
    if (best.presenceMinutes == 0 || top.presenceMinutes == 0) return null;

    return PersonalInsight(
      message: '«${top.company.name}» تعطيك دخلاً أكبر، لكن '
          '«${best.company.name}» تعطيك ${best.netPerHour.toStringAsFixed(0)} '
          'لكل ساعة مقابل ${top.netPerHour.toStringAsFixed(0)}',
      tone: InsightTone.neutral,
    );
  }

  /// استهلاك الإجازات — يُذكر عند الاقتراب من الرصيد أو تجاوزه.
  List<PersonalInsight> _leaveUsage(List<LeaveBalanceEntity> balances) {
    final insights = <PersonalInsight>[];

    for (final balance in balances) {
      if (balance.allowance <= 0) continue;

      if (balance.isOverdrawn) {
        insights.add(PersonalInsight(
          message: 'تجاوزت رصيد الإجازة ${balance.type.label} '
              'بـ${-balance.remaining} يوم',
          tone: InsightTone.negative,
        ));
        continue;
      }

      // الثمانون بالمئة عتبة تنبيه لا احتفال: ما دونها لا يستدعي قراراً.
      if (balance.used / balance.allowance >= 0.8) {
        insights.add(PersonalInsight(
          message: 'بقي ${balance.remaining} يوم من إجازتك '
              '${balance.type.label} (${balance.allowance})',
          tone: InsightTone.neutral,
        ));
      }
    }

    return insights;
  }
}
