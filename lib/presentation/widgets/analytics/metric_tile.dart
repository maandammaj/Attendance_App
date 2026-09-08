import 'package:flutter/material.dart';

/// خانة إحصائية مضغوطة تُستخدم في شبكات الملخص.
class MetricTile extends StatelessWidget {
  const MetricTile({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.color,
    this.hint,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? color;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = color ?? theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: accent),
            const SizedBox(height: 6),
          ],
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              value,
              style: theme.textTheme.titleLarge
                  ?.copyWith(color: accent, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 2),
          Text(label,
              style: theme.textTheme.bodySmall, maxLines: 2,
              overflow: TextOverflow.ellipsis),
          if (hint != null)
            Text(hint!,
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: theme.disabledColor)),
        ],
      ),
    );
  }
}
