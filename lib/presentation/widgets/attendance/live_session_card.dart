import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/design_tokens.dart';
import '../../../core/constants/theme.dart';
import '../../../core/utils/date_helpers.dart';
import '../../../core/utils/salary_calculator.dart';
import '../../../domain/entities/attendance_entity.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/company_provider.dart';
import '../common/pulsing_dot.dart';

/// البطاقة الرئيسية لليوم: الحالة، العدّاد الحيّ، المكتسب، والتقدّم نحو المطلوب.
///
/// تُحدَّث كل ثانية أثناء وجود جلسة مفتوحة فقط؛ خارج ذلك لا مؤقّت يعمل.
class LiveSessionCard extends ConsumerStatefulWidget {
  const LiveSessionCard({super.key});

  @override
  ConsumerState<LiveSessionCard> createState() => _LiveSessionCardState();
}

class _LiveSessionCardState extends ConsumerState<LiveSessionCard> {
  Timer? _ticker;
  DateTime _now = DateTime.now();

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  /// يشغّل المؤقّت عند وجود جلسة مفتوحة ويوقفه عند إغلاقها.
  void _syncTicker(bool isOpen) {
    if (isOpen && _ticker == null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() => _now = DateTime.now());
      });
    } else if (!isOpen && _ticker != null) {
      _ticker!.cancel();
      _ticker = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final today = ref.watch(todayAttendanceProvider).valueOrNull;
    final company = ref.watch(activeCompanyProvider).valueOrNull;

    final isOpen = today?.isOpen ?? false;
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _syncTicker(isOpen));

    final presenceMinutes = today?.presenceMinutesAt(_now) ?? 0;

    // قبل أول حضور لا سجل لليوم، والمطلوب معروف من الجدول رغم ذلك. قراءته
    // من السجل وحده كانت تعرض "—" فلا يرى المستخدم هدف يومه قبل أن يبدأه.
    final todayConfig = company?.configFor(_now);
    final requiredMinutes =
        today?.requiredMinutesTotal ?? todayConfig?.requiredMinutesTotal ?? 0;
    final isDayOff = today == null &&
        todayConfig != null &&
        (!todayConfig.isWorkingDay || todayConfig.isHoliday);
    final progress = requiredMinutes == 0
        ? 0.0
        : (presenceMinutes / requiredMinutes).clamp(0.0, 1.0);

    final earned = company == null
        ? 0.0
        : SalaryCalculator(company).calculateEarnedFromMinutes(
            presenceMinutes,
            today?.requiredHours ?? 0,
            today?.requiredMinutes ?? 0,
          );

    final currency = company?.currency ?? AppConstants.defaultCurrency;
    final gradient = isOpen
        ? AppPalette.activeGradient
        : AppPalette.brandGradient;

    final card = Container(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.card),
        gradient: LinearGradient(
          colors: gradient,
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        boxShadow: AppElevation.raised(palette),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isOpen) ...[
                const PulsingDot(color: Colors.white),
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: Text(
                  _statusLabel(today, isOpen),
                  style: theme.textTheme.titleSmall
                      ?.copyWith(color: Colors.white.withValues(alpha: 0.92)),
                ),
              ),
              Text(
                DateHelpers.getArabicDayName(DateTime.now()),
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: Colors.white.withValues(alpha: 0.75)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // المبلغ المكتسب هو ذروة الشاشة: أكبر رقم، وباللون المحجوز للمال.
          // الوقت تحته تفسيرٌ له، لا ندٌّ يزاحمه.
          _Earned(
            amount: earned,
            currency: currency,
            color: palette.accentOnBrand,
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Icon(Icons.schedule_rounded,
                  size: AppIconSize.sm,
                  color: Colors.white.withValues(alpha: 0.75)),
              const SizedBox(width: 6),
              Text(
                _elapsedLabel(presenceMinutes, _liveSeconds(today, isOpen), isOpen),
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: Colors.white.withValues(alpha: 0.82))
                    .merge(tabularFigures),
              ),
              if (requiredMinutes > 0)
                Text(
                  ' من ${DateHelpers.formatDurationCompact(requiredMinutes)}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.white.withValues(alpha: 0.58)),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: context.motion(AppDurations.slow),
              curve: AppCurves.emphasized,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 6,
                color: palette.accentOnBrand,
                backgroundColor: Colors.white.withValues(alpha: 0.18),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              _Metric(
                label: 'الجلسات',
                value: '${today?.sessions.length ?? 0}',
                icon: Icons.timeline_rounded,
              ),
              _Divider(),
              _Metric(
                label: 'الإضافي',
                value: DateHelpers.formatDurationCompact(
                    (today?.overtimeHours ?? 0) * 60 +
                        (today?.overtimeMinutes ?? 0)),
                icon: Icons.trending_up_rounded,
              ),
              _Divider(),
              _Metric(
                label: 'المطلوب',
                value: isDayOff
                    ? 'عطلة'
                    : requiredMinutes == 0
                    ? '—'
                    : DateHelpers.formatDurationCompact(requiredMinutes),
                icon: Icons.flag_outlined,
              ),
            ],
          ),
        ],
      ),
    );

    // الحركة تُتخطّى بالكامل لا تُشغَّل نحو بدايتها: تمرير target صفر يُبقي
    // fadeIn عند شفافية صفر، فتختفي البطاقة بدل أن تظهر ساكنة.
    if (context.prefersReducedMotion) return card;

    return card.animate().fadeIn(duration: AppDurations.medium).slideY(
          begin: 0.05,
          end: 0,
          duration: AppDurations.medium,
          curve: AppCurves.emphasized,
        );
  }

  static String _elapsedLabel(int minutes, int seconds, bool isOpen) {
    final hours = (minutes ~/ 60).toString().padLeft(2, '0');
    final mins = (minutes % 60).toString().padLeft(2, '0');
    // الثواني تظهر أثناء الجلسة فقط — بعد الإغلاق الرقم نهائي ولا يتحرّك.
    return isOpen
        ? '$hours:$mins:${seconds.toString().padLeft(2, '0')}'
        : '$hours:$mins';
  }

  int _liveSeconds(AttendanceEntity? today, bool isOpen) {
    final open = today?.openSession?.checkIn;
    if (!isOpen || open == null) return 0;
    return _now.difference(open).inSeconds % 60;
  }

  static String _statusLabel(AttendanceEntity? today, bool isOpen) {
    if (isOpen) return 'الدوام جارٍ الآن';
    if (today == null || today.sessions.isEmpty) return 'لم تبدأ دوامك بعد';
    return 'انتهى دوامك — ${today.sessionCount} جلسة';
  }
}

/// المبلغ المكتسب اليوم. أكبر عنصر في الشاشة كلها.
class _Earned extends StatelessWidget {
  const _Earned({
    required this.amount,
    required this.currency,
    required this.color,
  });

  final double amount;
  final String currency;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      textBaseline: TextBaseline.alphabetic,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      children: [
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: amount),
              duration: context.motion(AppDurations.slow),
              curve: AppCurves.emphasized,
              builder: (context, value, _) => Text(
                value.toStringAsFixed(0),
                style: theme.textTheme.displayLarge
                    ?.copyWith(color: color)
                    .merge(tabularFigures),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          currency,
          style: theme.textTheme.titleMedium
              ?.copyWith(color: color.withValues(alpha: 0.75)),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 30,
      color: Colors.white.withValues(alpha: 0.18),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.8)),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: theme.textTheme.titleSmall?.copyWith(color: Colors.white),
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall
                ?.copyWith(color: Colors.white.withValues(alpha: 0.72)),
          ),
        ],
      ),
    );
  }
}
