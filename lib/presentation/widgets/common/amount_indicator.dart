import 'package:flutter/material.dart';

import '../../../core/constants/design_tokens.dart';
import '../../../core/constants/theme.dart';

/// مؤشّر مبلغ واحد داخل بطاقة موقف: تسمية، أيقونة اتجاه، ثم الرقم.
///
/// مشترك بين الديون والحسابات — وهما شاشتا دفتر واحدة في نظر المستخدم،
/// فاختلاف شكل الملخّص بينهما كان يقرأ كتطبيقين لا تبويبين.
///
/// الرقم بلون الحبر لا بلون الدلالة: الأيقونة والخلفية تحملان الاتجاه،
/// فلا يزاحم اللونُ قراءةَ الرقم.
class AmountIndicator extends StatelessWidget {
  const AmountIndicator({
    super.key,
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
    required this.currency,
  });

  final String label;
  final double amount;
  final Color color;
  final IconData icon;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.field),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: AppIconSize.sm, color: color),
              const SizedBox(width: AppSpacing.xs),
              Text(label, style: theme.textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              '${amount.toStringAsFixed(0)} $currency',
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: palette.onSurface)
                  .merge(tabularFigures),
            ),
          ),
        ],
      ),
    );
  }
}
