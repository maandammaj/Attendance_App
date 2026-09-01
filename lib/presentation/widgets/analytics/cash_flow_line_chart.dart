import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/analytics_report_entity.dart';

/// خطّان متراكبان: الدخل مقابل المصروف عبر الزمن.
class CashFlowLineChart extends StatelessWidget {
  const CashFlowLineChart({
    super.key,
    required this.points,
    required this.currency,
  });

  final List<TimeSeriesPoint> points;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (points.length < 2) {
      return SizedBox(
        height: 120,
        child: Center(
          child: Text('تحتاج نقطتين على الأقل لرسم الاتجاه',
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
          child: LineChart(
            LineChartData(
              maxY: maxY,
              minY: 0,
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (spots) => spots.map((spot) {
                    final isIncome = spot.barIndex == 0;
                    return LineTooltipItem(
                      '${isIncome ? "دخل" : "مصروف"} ${spot.y.toStringAsFixed(0)} $currency',
                      TextStyle(
                        color: isIncome ? Colors.green.shade300 : Colors.red.shade300,
                        fontSize: 11,
                      ),
                    );
                  }).toList(),
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
                      _compact(value),
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
                      final step = (points.length / 6).ceil();
                      if (index % step != 0) return const SizedBox.shrink();
                      return Text(points[index].label,
                          style: theme.textTheme.labelSmall);
                    },
                  ),
                ),
              ),
              lineBarsData: [
                _line(
                  [
                    for (int i = 0; i < points.length; i++)
                      FlSpot(i.toDouble(), points[i].value),
                  ],
                  Colors.green.shade600,
                ),
                _line(
                  [
                    for (int i = 0; i < points.length; i++)
                      FlSpot(i.toDouble(), points[i].secondaryValue),
                  ],
                  theme.colorScheme.error,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Legend(color: Colors.green.shade600, label: 'الدخل'),
            const SizedBox(width: 20),
            _Legend(color: theme.colorScheme.error, label: 'المصروف'),
          ],
        ),
      ],
    );
  }

  LineChartBarData _line(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.28,
      preventCurveOverShooting: true,
      color: color,
      barWidth: 2.5,
      dotData: FlDotData(
        show: spots.length <= 12,
        getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
          radius: 3,
          color: color,
          strokeWidth: 0,
        ),
      ),
      belowBarData: BarAreaData(
        show: true,
        color: color.withValues(alpha: 0.12),
      ),
    );
  }

  static String _compact(double value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}م';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}ألف';
    return value.toStringAsFixed(0);
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
