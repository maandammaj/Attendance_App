import 'package:flutter/material.dart';

import '../../../../config/routes.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/constants/theme.dart';
import '../../../providers/dashboard_provider.dart';

/// أرقام الدوام لهذا الشهر: الأيام، الساعات، والرصيد المالي الناتج عنها.
///
/// موضعها في لوحة الميزانية مقصود — الراتب أعلاها نتيجةٌ لهذه الأرقام،
/// ورؤيتهما معاً هي ما يفسّر لماذا الرقم كذلك.
class AttendanceSummaryCard extends StatelessWidget {
  const AttendanceSummaryCard({super.key, required this.data});

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    final balance = data.overtimeValueNet;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: () => Navigator.pushNamed(context, AppRoutes.analytics),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Row(
                children: [
                  _Figure(
                    value: '${data.attendedDays}',
                    label: 'يوم حضور',
                    hint: 'من ${data.expectedWorkingDays}',
                    color: palette.primary,
                  ),
                  _Sep(),
                  _Figure(
                    value: '${data.absentDays}',
                    label: 'يوم غياب',
                    hint: data.absentDays == 0 ? 'ممتاز' : 'يخصم',
                    color: data.absentDays == 0
                        ? palette.positive
                        : palette.negative,
                  ),
                  _Sep(),
                  _Figure(
                    value: '${(data.attendanceRate * 100).toStringAsFixed(0)}%',
                    label: 'نسبة الحضور',
                    hint: 'من أيام العمل',
                    color: palette.onSurface,
                  ),
                ],
              ),
              const Divider(height: AppSpacing.xl),

              // الساعات: المنجز مقابل المطلوب في شريط واحد، فالنسبة تُقرأ
              // دون حساب ذهني.
              Row(
                children: [
                  Expanded(
                    child: Text('الساعات المنجزة',
                        style: theme.textTheme.bodyMedium),
                  ),
                  Text(
                    '${data.workedHours.toStringAsFixed(1)}',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: palette.onSurface)
                        .merge(tabularFigures),
                  ),
                  Text(
                    ' / ${data.requiredHours.toStringAsFixed(1)} ساعة',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: palette.onSurfaceVariant)
                        .merge(tabularFigures),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(
                      begin: 0, end: data.completionRate.clamp(0.0, 1.0)),
                  duration: context.motion(AppDurations.slow),
                  curve: AppCurves.emphasized,
                  builder: (context, value, _) => LinearProgressIndicator(
                    value: value,
                    minHeight: 6,
                    color: palette.primary,
                    backgroundColor: palette.surfaceAlt,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: _HoursChip(
                      icon: Icons.trending_up_rounded,
                      label: 'إضافي',
                      hours: data.overtimeHours,
                      amount: data.totalOvertimeValue,
                      currency: data.currency,
                      color: palette.positive,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _HoursChip(
                      icon: Icons.trending_down_rounded,
                      label: 'عجز وغياب',
                      hours: data.deficitHours,
                      amount: data.totalDeficitValue,
                      currency: data.currency,
                      color: palette.negative,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      balance >= 0 ? 'صافي لصالحك' : 'صافي عليك',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    '${balance >= 0 ? '+' : ''}${balance.toStringAsFixed(0)} ${data.currency}',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(
                            color: balance >= 0
                                ? palette.positive
                                : palette.negative)
                        .merge(tabularFigures),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({
    required this.value,
    required this.label,
    required this.hint,
    required this.color,
  });

  final String value;
  final String label;
  final String hint;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(color: color)
                  .merge(tabularFigures),
            ),
          ),
          const SizedBox(height: 2),
          Text(label,
              style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
          Text(hint,
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: context.palette.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _Sep extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 40,
        color: context.palette.outline,
      );
}

class _HoursChip extends StatelessWidget {
  const _HoursChip({
    required this.icon,
    required this.label,
    required this.hours,
    required this.amount,
    required this.currency,
    required this.color,
  });

  final IconData icon;
  final String label;
  final double hours;
  final double amount;
  final String currency;
  final Color color;

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
              const SizedBox(width: 6),
              Expanded(
                  child: Text(label, style: theme.textTheme.bodySmall)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              '${hours.toStringAsFixed(1)} ساعة',
              style: theme.textTheme.titleSmall
                  ?.copyWith(color: palette.onSurface)
                  .merge(tabularFigures),
            ),
          ),
          Text(
            '${amount.toStringAsFixed(0)} $currency',
            style: theme.textTheme.labelSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
