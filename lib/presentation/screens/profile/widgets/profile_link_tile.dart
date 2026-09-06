import 'package:flutter/material.dart';

import '../../../../core/constants/design_tokens.dart';

/// مدخل شاشة لا تملك تبويباً في الشريط السفلي.
class ProfileLinkTile extends StatelessWidget {
  const ProfileLinkTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    this.tint,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String route;

  /// لون هوية المقصد. بلا لون يقع على لون العلامة.
  ///
  /// ستّة مداخل بلون واحد تُقرأ ككتلة رمادية واحدة لا كقائمة يُنتقى منها؛
  /// اللون هنا هو ما يجعل المدخل يُلمح قبل قراءة نصّه.
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final color = tint ?? palette.primary;

    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.sm),
      child: Material(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.field),
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, route),
          borderRadius: BorderRadius.circular(AppRadius.field),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.field),
              border: Border.all(color: palette.outline),
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.badge),
                  ),
                  child: Icon(icon, color: color, size: AppIconSize.md),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleSmall),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: palette.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: AppIconSize.sm,
                  color: palette.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
