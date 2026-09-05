import 'package:flutter/material.dart';

import '../../../core/constants/design_tokens.dart';
import '../../../core/utils/date_helpers.dart';
import '../../../domain/entities/attendance_entity.dart';
import '../common/animated_entrance.dart';
import '../common/pulsing_dot.dart';

/// خط زمني لجلسات يوم واحد، مع الفجوات بينها.
///
/// الفجوة معروضة صراحةً لأنها هي ما يفسّر فرق العجز عن الساعات المطلوبة
/// حين يخرج المستخدم ويعود.
class SessionTimeline extends StatelessWidget {
  const SessionTimeline({
    super.key,
    required this.sessions,
    this.onEditSession,
  });

  final List<WorkSessionEntity> sessions;
  final void Function(int index)? onEditSession;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (sessions.isEmpty) {
      // نسخة مضغوطة من حالة الفراغ: هذه تعيش داخل بطاقة، فـ`EmptyState`
      // بحشوته الكاملة يضاعف ارتفاعها بلا داعٍ.
      final palette = context.palette;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            Icon(Icons.schedule_rounded,
                size: AppIconSize.md, color: palette.onSurfaceVariant),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'لا جلسات بعد — سجّل حضورك أو أضف جلسة يدوياً',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      );
    }

    final rows = <Widget>[];
    for (int i = 0; i < sessions.length; i++) {
      if (i > 0) {
        final gap = _gapMinutes(sessions[i - 1], sessions[i]);
        if (gap > 0) rows.add(_GapRow(minutes: gap));
      }
      rows.add(_SessionRow(
        session: sessions[i],
        index: i,
        isLast: i == sessions.length - 1,
        onTap: onEditSession == null ? null : () => onEditSession!(i),
      ));
    }

    return Column(
      children: [
        for (int i = 0; i < rows.length; i++)
          AnimatedEntrance(index: i, slide: 0.05, child: rows[i]),
      ],
    );
  }

  static int _gapMinutes(WorkSessionEntity previous, WorkSessionEntity next) {
    final from = previous.checkOut;
    final to = next.checkIn;
    if (from == null || to == null) return 0;
    final minutes = to.difference(from).inMinutes;
    return minutes < 0 ? 0 : minutes;
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({
    required this.session,
    required this.index,
    required this.isLast,
    this.onTap,
  });

  final WorkSessionEntity session;
  final int index;
  final bool isLast;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final isOpen = session.isOpen;
    final color = isOpen ? palette.positive : theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.field),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 6),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 26,
                child: Column(
                  children: [
                    if (isOpen)
                      PulsingDot(color: color, size: 9)
                    else
                      Container(
                        width: 11,
                        height: 11,
                        margin: const EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          margin: const EdgeInsets.symmetric(vertical: 3),
                          color: theme.dividerColor,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('الجلسة ${index + 1}',
                              style: theme.textTheme.titleSmall),
                          const SizedBox(width: 8),
                          if (session.isBiometricVerified)
                            Icon(Icons.verified_user_rounded,
                                size: 14, color: palette.positive)
                          else
                            Icon(Icons.edit_note_rounded,
                                size: 14, color: theme.disabledColor),
                          const Spacer(),
                          Text(
                            isOpen
                                ? 'جارية'
                                : DateHelpers.formatDurationCompact(
                                    session.minutesUntil(DateTime.now())),
                            style: theme.textTheme.labelSmall
                                ?.copyWith(color: color),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${session.checkIn == null ? "—" : DateHelpers.formatTime(session.checkIn!)}'
                        '  ←  '
                        '${session.checkOut == null ? "الآن" : DateHelpers.formatTime(session.checkOut!)}',
                        style: theme.textTheme.bodySmall,
                      ),
                      if (session.note != null && session.note!.isNotEmpty)
                        Text(session.note!,
                            style: theme.textTheme.labelSmall
                                ?.copyWith(color: theme.disabledColor)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GapRow extends StatelessWidget {
  const _GapRow({required this.minutes});

  final int minutes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 36, bottom: 8),
      child: Row(
        children: [
          Icon(Icons.pause_circle_outline,
              size: 14, color: theme.disabledColor),
          const SizedBox(width: 6),
          Text(
            'انقطاع ${DateHelpers.formatDurationCompact(minutes)}',
            style:
                theme.textTheme.labelSmall?.copyWith(color: theme.disabledColor),
          ),
        ],
      ),
    );
  }
}
