import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/analytics_report_entity.dart';

/// دائري للفئات مع مفتاح جانبي. الفئات الصغيرة تُدمج في شريحة "أخرى"
/// حتى لا تصبح الحلقة غير مقروءة.
class CategoryPieChart extends StatefulWidget {
  const CategoryPieChart({
    super.key,
    required this.items,
    required this.currency,
  });

  final List<CategoryBreakdownItem> items;
  final String currency;

  static const _palette = <Color>[
    Color(0xFF6750A4),
    Color(0xFF00897B),
    Color(0xFFEF6C00),
    Color(0xFF1E88E5),
    Color(0xFFC2185B),
    Color(0xFF43A047),
    Color(0xFF8E24AA),
    Color(0xFF757575),
  ];

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (widget.items.isEmpty) {
      return SizedBox(
        height: 120,
        child: Center(
          child: Text('لا توجد مصروفات مسجّلة',
              style: theme.textTheme.bodySmall),
        ),
      );
    }

    final slices = _collapse(widget.items);
    final total = slices.fold(0.0, (sum, item) => sum + item.amount);

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 52,
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  setState(() {
                    _touchedIndex = event.isInterestedForInteractions
                        ? (response?.touchedSection?.touchedSectionIndex ?? -1)
                        : -1;
                  });
                },
              ),
              sections: [
                for (int i = 0; i < slices.length; i++)
                  PieChartSectionData(
                    value: slices[i].amount,
                    color: CategoryPieChart
                        ._palette[i % CategoryPieChart._palette.length],
                    radius: _touchedIndex == i ? 62 : 54,
                    title: slices[i].share >= 0.07
                        ? '${(slices[i].share * 100).toStringAsFixed(0)}%'
                        : '',
                    titleStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        for (int i = 0; i < slices.length; i++)
          _LegendRow(
            color:
                CategoryPieChart._palette[i % CategoryPieChart._palette.length],
            item: slices[i],
            total: total,
            currency: widget.currency,
            isHighlighted: _touchedIndex == i,
          ),
      ],
    );
  }

  /// يبقي أكبر سبع فئات ويجمع الباقي في "أخرى".
  List<CategoryBreakdownItem> _collapse(List<CategoryBreakdownItem> items) {
    if (items.length <= 8) return items;

    final head = items.take(7).toList();
    final tail = items.skip(7);
    final tailAmount = tail.fold(0.0, (sum, item) => sum + item.amount);
    final tailShare = tail.fold(0.0, (sum, item) => sum + item.share);
    final tailCount =
        tail.fold(0, (sum, item) => sum + item.transactionCount);

    return [
      ...head,
      CategoryBreakdownItem(
        name: 'أخرى (${items.length - 7})',
        amount: tailAmount,
        share: tailShare,
        transactionCount: tailCount,
      ),
    ];
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.item,
    required this.total,
    required this.currency,
    required this.isHighlighted,
  });

  final Color color;
  final CategoryBreakdownItem item;
  final double total;
  final String currency;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 6, 8, 6),
      decoration: BoxDecoration(
        color: isHighlighted ? color.withValues(alpha: 0.08) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(3)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(item.name,
                style: theme.textTheme.bodyMedium, overflow: TextOverflow.ellipsis),
          ),
          Text(
            '${item.amount.toStringAsFixed(0)} $currency',
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 42,
            child: Text(
              '${(item.share * 100).toStringAsFixed(1)}%',
              textAlign: TextAlign.end,
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
