import 'package:flutter/material.dart';

import '../../../../core/constants/design_tokens.dart';
import '../../../../core/utils/date_helpers.dart';
import '../../../../domain/entities/profile_entity.dart';

/// حصيلة الجدول: أيام العمل، الساعات الأسبوعية، والشهرية التقديرية.
///
/// المعامل 4.33 هو نفسه المستخدم في `SalaryCalculator` لاشتقاق أجر الساعة،
/// فيرى المستخدم هنا الرقم الذي سيُحسب عليه راتبه.
class ScheduleSummary extends StatelessWidget {
  const ScheduleSummary({super.key, required this.schedule});

  final List<WorkDayConfigEntity> schedule;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final active =
        schedule.where((day) => day.isWorkingDay && !day.isHoliday).toList();
    final weeklyMinutes =
        active.fold(0, (sum, day) => sum + day.requiredMinutesTotal);
    final monthlyHours = (weeklyMinutes / 60) * 4.33;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.card),
        gradient: LinearGradient(
          colors: AppPalette.brandGradient,
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        boxShadow: AppElevation.raised(palette),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('حصيلة جدولك',
              style: theme.textTheme.titleSmall
                  ?.copyWith(color: Colors.white.withValues(alpha: 0.9))),
          const SizedBox(height: 14),
          Row(
            children: [
              _Stat(value: '${active.length}', label: 'يوم عمل'),
              _Divider(),
              _Stat(
                value: (weeklyMinutes / 60).toStringAsFixed(1),
                label: 'ساعة أسبوعياً',
              ),
              _Divider(),
              _Stat(
                value: monthlyHours.toStringAsFixed(0),
                label: 'ساعة شهرياً',
              ),
            ],
          ),
          if (active.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final day in active)
                  Container(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 4, 10, 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      DateHelpers.arabicDayNameOfScheduleDay(day.dayOfWeek),
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(color: Colors.white)),
          ),
          Text(label,
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: Colors.white.withValues(alpha: 0.78))),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 34,
      color: Colors.white.withValues(alpha: 0.22),
    );
  }
}
