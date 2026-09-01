import 'package:flutter/material.dart';

import '../../../../core/constants/design_tokens.dart';

class SetupStepHeader extends StatelessWidget {
  const SetupStepHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 30, color: palette.primary),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(subtitle,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: palette.onSurfaceVariant)),
        ],
      ),
    );
  }
}
