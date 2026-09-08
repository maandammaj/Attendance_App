import 'package:flutter/material.dart';

import '../../../../core/constants/design_tokens.dart';
import '../../../../core/constants/theme.dart';
import '../../../../domain/entities/analytics_report_entity.dart';
import '../../../widgets/common/animated_entrance.dart';

/// المصروفات حسب الفئة: أعمدة أفقية مرتّبة تنازلياً.
///
/// أعمدة لا حلقة — الحلقة تُقارن بالزاوية، والعين تقرأ الطول أدقّ منها،
/// وأسماء الفئات العربية لا تسع داخل شرائح صغيرة على شاشة هاتف.
/// الألوان تُسند بالترتيب ولا تُدوَّر؛ ما بعد السابعة ينضم إلى "أخرى".
class SpendingBreakdown extends StatelessWidget {
  const SpendingBreakdown({
    super.key,
    required this.items,
    required this.currency,
  });

  final List<CategoryBreakdownItem> items;
  final String currency;

  static const _visibleSlots = 7;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    final rows = _collapse(items);
    final total = rows.fold(0.0, (sum, item) => sum + item.amount);
    final largest = rows.isEmpty ? 0.0 : rows.first.amount;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('إجمالي المصروفات',
                      style: theme.textTheme.bodyMedium),
                ),
                Text(
                  '${total.toStringAsFixed(0)} $currency',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: palette.onSurface)
                      .merge(tabularFigures),
                ),
              ],
            ),
            const Divider(height: AppSpacing.xl),
            for (int i = 0; i < rows.length; i++)
              AnimatedEntrance(
                index: i,
                slide: 0.04,
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.only(bottom: AppSpacing.md),
                  child: _CategoryRow(
                    item: rows[i],
                    // اللون يتبع الفئة بترتيب ثبوتها، لا رتبتها في هذا الشهر.
                    color: palette.categorical[i % palette.categorical.length],
                    fraction: largest <= 0 ? 0 : rows[i].amount / largest,
                    currency: currency,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// يبقي أكبر [_visibleSlots] فئات ويجمع الباقي في "أخرى" — لا لون تاسع
  /// مولّد، فهو لن يكون مميّزاً تحت عمى الألوان.
  static List<CategoryBreakdownItem> _collapse(
      List<CategoryBreakdownItem> items) {
    if (items.length <= _visibleSlots + 1) return items;

    final head = items.take(_visibleSlots).toList();
    final tail = items.skip(_visibleSlots);
    return [
      ...head,
      CategoryBreakdownItem(
        name: 'أخرى (${items.length - _visibleSlots})',
        amount: tail.fold(0.0, (sum, item) => sum + item.amount),
        share: tail.fold(0.0, (sum, item) => sum + item.share),
        transactionCount:
            tail.fold(0, (sum, item) => sum + item.transactionCount),
      ),
    ];
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.item,
    required this.color,
    required this.fraction,
    required this.currency,
  });

  final CategoryBreakdownItem item;
  final Color color;
  final double fraction;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration:
                  BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                item.name,
                style: theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // النص يرتدي لون الحبر لا لون السلسلة؛ المربّع الملوّن يحمل الهوية.
            Text(
              '${item.amount.toStringAsFixed(0)} $currency',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: palette.onSurface)
                  .merge(tabularFigures),
            ),
            const SizedBox(width: AppSpacing.sm),
            SizedBox(
              width: 44,
              child: Text(
                '${(item.share * 100).toStringAsFixed(0)}%',
                textAlign: TextAlign.end,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: palette.onSurfaceVariant)
                    .merge(tabularFigures),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LayoutBuilder(
          builder: (context, constraints) => Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: palette.surfaceAlt,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: fraction.clamp(0.0, 1.0)),
                duration: context.motion(AppDurations.slow),
                curve: AppCurves.emphasized,
                builder: (context, value, _) => Container(
                  height: 8,
                  width: constraints.maxWidth * value,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
