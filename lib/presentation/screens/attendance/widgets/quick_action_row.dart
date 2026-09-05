import 'package:flutter/material.dart';

import '../../../../core/constants/design_tokens.dart';

/// ثلاثة إجراءات سريعة تحت بطاقة الحالة.
///
/// الثلاثة أنداد وكلها تنقّل، فتتشارك سطحاً محايداً واحداً وتُميَّز بأيقونتها
/// واسمها. كانت تحمل `info` و`primary` و`warning` — ألوان دلالية أُنفقت على
/// زينة: الكهرماني يقول إن في «التذكيرات» خطأ ما، ولا خطأ فيها. وإخلاؤها من
/// لون العلامة يترك الحضور وحده يحمله، وهو الإجراء الرئيسي فعلاً.
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
    return Row(
      children: [
        _Action(
          icon: Icons.add_alarm_rounded,
          label: 'جلسة يدوية',
          onTap: onManualEntry,
        ),
        const SizedBox(width: AppSpacing.md),
        _Action(
          icon: Icons.history_rounded,
          label: 'السجل',
          onTap: onHistory,
        ),
        const SizedBox(width: AppSpacing.md),
        _Action(
          icon: Icons.notifications_active_outlined,
          label: 'التذكيرات',
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
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final radius = BorderRadius.circular(AppRadius.field);

    return Expanded(
      child: Material(
        color: palette.surface,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(color: palette.outline),
            ),
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.symmetric(vertical: AppSpacing.lg),
              child: Column(
                children: [
                  Icon(icon, color: palette.primary, size: AppIconSize.lg),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    label,
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: palette.onSurface),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
