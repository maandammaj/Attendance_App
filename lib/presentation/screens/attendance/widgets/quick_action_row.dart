import 'package:flutter/material.dart';

import '../../../../core/constants/design_tokens.dart';

/// ثلاثة إجراءات سريعة تحت بطاقة الحالة.
class QuickActionRow extends StatelessWidget {
  const QuickActionRow({
    super.key,
    required this.onManualEntry,
    required this.onHistory,
    required this.onReminders,
  });

  final VoidCallback onManualEntry;
  final VoidCallback onHistory;
  final VoidCallback onReminders;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      children: [
        _Action(
          icon: Icons.add_alarm_rounded,
          label: 'جلسة يدوية',
          color: palette.info,
          onTap: onManualEntry,
        ),
        const SizedBox(width: 10),
        _Action(
          icon: Icons.history_rounded,
          label: 'السجل',
          color: palette.primary,
          onTap: onHistory,
        ),
        const SizedBox(width: 10),
        _Action(
          icon: Icons.notifications_active_outlined,
          label: 'التذكيرات',
          color: palette.warning,
          onTap: onReminders,
        ),
      ],
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Material(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.field),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.field),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 14),
            child: Column(
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(height: 6),
                Text(label,
                    style: theme.textTheme.labelSmall?.copyWith(color: color)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
