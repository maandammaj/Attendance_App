import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

/// رادار لمتوسط ساعات كل يوم أسبوع — يُظهر أي الأيام يحمل العبء الأكبر.
class WeekdayRadarChart extends StatelessWidget {
  const WeekdayRadarChart({super.key, required this.averageHours});

  /// سبع قيم بترقيم المشروع (0 = السبت … 6 = الجمعة).
  final List<double> averageHours;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxHours = averageHours.fold(0.0, (a, b) => a > b ? a : b);

    if (maxHours <= 0) {
      return SizedBox(
        height: 120,
        child: Center(
          child: Text('لا توجد ساعات مسجّلة في هذه الفترة',
              style: theme.textTheme.bodySmall),
        ),
      );
    }

    return SizedBox(
      height: 250,
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.polygon,
          // الرادار يرفض قيمة صفرية في كل الرؤوس، والقصوى تُضبط يدوياً
          // حتى لا يتغير مقياس الشكل بين الفترات.
          tickCount: 4,
          ticksTextStyle: const TextStyle(fontSize: 0, color: Colors.transparent),
          radarBorderData:
              BorderSide(color: theme.dividerColor.withValues(alpha: 0.4)),
          gridBorderData:
              BorderSide(color: theme.dividerColor.withValues(alpha: 0.3)),
          tickBorderData:
              BorderSide(color: theme.dividerColor.withValues(alpha: 0.2)),
          getTitle: (index, _) => RadarChartTitle(
            text: AppConstants.arabicDays[index],
            positionPercentageOffset: 0.12,
          ),
          titleTextStyle: theme.textTheme.labelSmall,
          dataSets: [
            RadarDataSet(
              fillColor: theme.colorScheme.primary.withValues(alpha: 0.22),
              borderColor: theme.colorScheme.primary,
              borderWidth: 2,
              entryRadius: 3,
              dataEntries: [
                for (final hours in averageHours) RadarEntry(value: hours),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
