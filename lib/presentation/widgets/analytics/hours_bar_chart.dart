import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/design_tokens.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/analytics_report_entity.dart';

/// أعمدة مكدّسة: الساعات الرسمية أسفل والإضافي فوقها لكل يوم/شهر.
class HoursBarChart extends StatelessWidget {
  const HoursBarChart({super.key, required this.points});

  final List<TimeSeriesPoint> points;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    if (points.isEmpty) return const _NoData();

    final maxValue = points
        .map((point) => point.value + point.secondaryValue)
        .fold(0.0, (a, b) => a > b ? a : b);
    // مساحة علوية 15% حتى لا يلامس أطول عمود سقف الرسم.
    final maxY = maxValue <= 0 ? 8.0 : maxValue * 1.15;

    // يوم واحد يحتاج عرضاً ثابتاً حتى تبقى التسميات مقروءة، فنمرّر أفقياً.
    final chartWidth = (points.length * 26).toDouble();

    return SizedBox(
      height: 220,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        child: SizedBox(
          width: chartWidth < 320 ? 320 : chartWidth,
          child: BarChart(
            BarChartData(
              maxY: maxY,
              alignment: BarChartAlignment.spaceAround,
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, _, rod, __) {
                    final point = points[group.x];
                    return BarTooltipItem(
                      '${point.label}\n',
                      theme.textTheme.bodySmall!
                          .copyWith(color: Colors.white, fontSize: 11),
                      children: [
                        TextSpan(
                          text:
                              'رسمي ${point.value.toStringAsFixed(1)}س\nإضافي ${point.secondaryValue.toStringAsFixed(1)}س',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    );
                  },
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
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 34,
                    interval: maxY / 4,
                    getTitlesWidget: (value, _) => Text(
                      value.toStringAsFixed(0),
                      style: theme.textTheme.labelSmall,
                    ),
                  ),
                ),
                leftTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 22,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      if (index < 0 || index >= points.length) {
                        return const SizedBox.shrink();
                      }
                      // كثافة التسميات تتكيّف مع عدد الأعمدة.
                      final step = points.length > 20 ? 5 : 2;
                      if (index % step != 0) return const SizedBox.shrink();
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
                    barRods: [
                      BarChartRodData(
                        toY: points[i].value + points[i].secondaryValue,
                        width: 12,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4)),
                        rodStackItems: [
                          BarChartRodStackItem(
                              0, points[i].value, theme.colorScheme.primary),
                          BarChartRodStackItem(
                            points[i].value,
                            points[i].value + points[i].secondaryValue,
                            palette.positive,
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NoData extends StatelessWidget {
  const _NoData();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Center(
        child: Text('لا توجد بيانات في هذه الفترة',
            style: Theme.of(context).textTheme.bodySmall),
      ),
    );
  }
}
