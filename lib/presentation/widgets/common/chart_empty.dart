import 'package:flutter/material.dart';

import '../../../core/constants/design_tokens.dart';

/// فراغ رسم بياني: أيقونة هادئة وسطر يقول لماذا لا شيء هنا.
///
/// ليست [EmptyState] — تلك تملأ شاشة وتحمل إجراءً، وهذه تعيش داخل بطاقة
/// إلى جانب رسوم أخرى. توحيدها يمنع سبعة نصوص عارية مختلفة الارتفاع
/// واللون داخل الشاشة الواحدة.
class ChartEmpty extends StatelessWidget {
  const ChartEmpty({
    super.key,
    required this.message,
    this.icon = Icons.bar_chart_rounded,
    this.height = 120,
  });

  final String message;
  final IconData icon;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    return SizedBox(
      height: height,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppIconSize.lg, color: palette.onSurfaceVariant),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: palette.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
