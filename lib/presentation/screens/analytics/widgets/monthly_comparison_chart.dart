import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entities/analytics_report_entity.dart';

/// عمودان متجاوران لكل شهر: المستحق مقابل المصروف.
class MonthlyComparisonChart extends StatelessWidget {
  const MonthlyComparisonChart({
    super.key,
    required this.points,
    required this.currency,
  });

  final List<TimeSeriesPoint> points;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (points.isEmpty) {
      return SizedBox(
        height: 100,
        child: Center(
          child: Text('لا توجد بيانات للمقارنة',
              style: theme.textTheme.bodySmall),
        ),
      );
    }

    final maxValue = points
        .expand((point) => [point.value, point.secondaryValue])
        .fold(0.0, (a, b) => a > b ? a : b);
    final maxY = maxValue <= 0 ? 100.0 : maxValue * 1.2;

    return Column(
      children: [
        SizedBox(
          height: 210,
          child: BarChart(
            BarChartData(
              maxY: maxY,
              alignment: BarChartAlignment.spaceAround,
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, _, rod, rodIndex) => BarTooltipItem(
                    '${points[group.x].label}\n${rodIndex == 0 ? "المستحق" : "المصروف"} ${rod.toY.toStringAsFixed(0)} $currency',
                    const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ),
              gridData: FlGridData(
                drawVerticalLine: false,
                horizontalInterval: maxY / 4,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: theme.dividerColor.withValues(alpha: 0.25),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 44,
                    interval: maxY / 4,
                    getTitlesWidget: (value, _) => Text(
                      value >= 1000
                          ? '${(value / 1000).toStringAsFixed(0)}ألف'
                          : value.toStringAsFixed(0),
                      style: theme.textTheme.labelSmall,
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 22,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      if (index < 0 || index >= points.length) {
                        return const SizedBox.shrink();
                      }
                      return Text(points[index].label,
                          style: theme.textTheme.labelSmall);
                    },
                  ),
                ),
              ),
              barGroups: [
                for (int i = 0; i < points.length; i++)
                  BarChartGroupData(
                    x: i,
                    barsSpace: 3,
                    barRods: [
                      BarChartRodData(
                        toY: points[i].value,
                        width: 10,
                        color: theme.colorScheme.primary,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(3)),
                      ),
                      BarChartRodData(
                        toY: points[i].secondaryValue,
                        width: 10,
                        color: theme.colorScheme.error,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(3)),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Legend(color: theme.colorScheme.primary, label: 'المستحق'),
            const SizedBox(width: 20),
            _Legend(color: theme.colorScheme.error, label: 'المصروف'),
          ],
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration:
              BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
