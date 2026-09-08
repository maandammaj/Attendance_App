import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/constants/design_tokens.dart';
import '../../core/constants/theme.dart';

/// صف دين واحد.
///
/// بلا هوامش خاصة: القائمة تملك الهامش الأفقي والصفّ يملك الفاصل الرأسي.
/// الهامش الداخلي السابق كان يُزيح البطاقة 16 بكسل عن خلفية السحب الحمراء
/// الملاصقة للحافة، فيظهر الأحمر بارزاً من تحت البطاقة عند السحب.
class DebtItemCard extends StatelessWidget {
  const DebtItemCard({
    super.key,
    required this.title,
    required this.amount,
    required this.isDebt,
    required this.date,
    required this.currency,
  });

  final String title;
  final double amount;
  final bool isDebt;
  final DateTime date;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final color = isDebt ? palette.negative : palette.positive;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: palette.outline),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.field),
            ),
            child: Icon(
              isDebt ? Icons.north_east_rounded : Icons.south_west_rounded,
              color: color,
              size: AppIconSize.md,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('yyyy/MM/dd').format(date),
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: palette.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${amount.toStringAsFixed(0)} $currency',
            style: theme.textTheme.titleSmall
                ?.copyWith(color: color)
                .merge(tabularFigures),
          ),
        ],
      ),
    );
  }
}
