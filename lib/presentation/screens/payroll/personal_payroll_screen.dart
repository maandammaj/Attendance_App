import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/design_tokens.dart';
import '../../../core/utils/arabic_plural.dart';
import '../../../core/utils/date_helpers.dart';
import '../../../domain/entities/payroll_entity.dart';
import '../../../domain/entities/personal_insight_entity.dart';
import '../../providers/payroll_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/state_switcher.dart';
import '../../../core/constants/currencies.dart';

/// دخل المستخدم من كل جهاته في شهر.
class PersonalPayrollScreen extends ConsumerWidget {
  const PersonalPayrollScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final payrollAsync =
        ref.watch(personalPayrollProvider(year: now.year, month: now.month));
    final currency = AppCurrency.wordOf(ref.watch(profileProvider).value?.currency);

    return Scaffold(
      appBar: AppBar(
        title: const Text('دخلي هذا الشهر'),
        centerTitle: true,
      ),
      body: StateSwitcher(
        value: payrollAsync,
        skeletonHeight: 200,
        onRetry: () => ref.invalidate(personalPayrollProvider),
        builder: (payroll) {
          if (payroll.workplaces.isEmpty) {
            return const EmptyState(
              icon: Icons.account_balance_wallet_rounded,
              title: 'لا جهات عمل',
              message: 'أضف جهة عمل ليُحسب دخلك منها.',
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              _TotalCard(payroll: payroll, currency: currency),
              const SizedBox(height: AppSpacing.lg),
              _MonthSummary(payroll: payroll),
              const SizedBox(height: AppSpacing.xl),
              SectionHeader(
                title: 'من أين جاء',
                subtitle: DateHelpers.arabicMonths[now.month - 1],
              ),
              for (final workplace in payroll.workplaces)
                _WorkplaceCard(workplace: workplace, currency: currency),
              const SizedBox(height: AppSpacing.md),
              _Insights(year: now.year, month: now.month),
            ],
          );
        },
      ),
    );
  }
}

class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.payroll, required this.currency});

  final PersonalPayroll payroll;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.card),
        gradient: const LinearGradient(
          colors: AppPalette.brandGradient,
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        boxShadow: AppElevation.raised(palette),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'إجمالي دخلك من ${ArabicPlural.workplaces(payroll.workplaces.length)}',
            style: theme.textTheme.titleSmall
                ?.copyWith(color: Colors.white.withValues(alpha: 0.9)),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    payroll.totalNet.toStringAsFixed(0),
                    style: theme.textTheme.displayLarge
                        ?.copyWith(color: palette.accentOnBrand),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(currency,
                  style: theme.textTheme.titleMedium?.copyWith(
                      color: palette.accentOnBrand.withValues(alpha: 0.75))),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              _TotalPart(
                  label: 'الأساسي',
                  value: payroll.totalBasic,
                  currency: currency),
              _TotalPart(
                  label: 'الإضافي',
                  value: payroll.totalOvertime,
                  currency: currency),
              _TotalPart(
                  label: 'الخصم',
                  value: payroll.totalDeductions,
                  currency: currency),
            ],
          ),
        ],
      ),
    );
  }
}

class _TotalPart extends StatelessWidget {
  const _TotalPart({
    required this.label,
    required this.value,
    required this.currency,
  });

  final String label;
  final double value;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${value.toStringAsFixed(0)} $currency',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: Colors.white)),
          Text(label,
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: Colors.white.withValues(alpha: 0.7))),
        ],
      ),
    );
  }
}

/// ملخّص الشهر: الساعات والإضافي والإجازات إلى جانب المال.
///
/// المال وحده لا يفسّر نفسه — 128,500 عن 184 ساعة غير 128,500 عن 90.
class _MonthSummary extends StatelessWidget {
  const _MonthSummary({required this.payroll});

  final PersonalPayroll payroll;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            _SummaryCell(
              label: 'ساعات العمل',
              value: DateHelpers.formatDurationCompact(
                  payroll.totalWorkedMinutes),
            ),
            _SummaryCell(
              label: 'الإضافي',
              value: DateHelpers.formatDurationCompact(
                  payroll.totalOvertimeMinutes),
            ),
            _SummaryCell(
              label: 'الإجازات',
              value: ArabicPlural.days(payroll.totalLeaveDays),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCell extends StatelessWidget {
  const _SummaryCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    return Expanded(
      child: Column(
        children: [
          Text(value, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(label,
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: palette.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _WorkplaceCard extends StatelessWidget {
  const _WorkplaceCard({required this.workplace, required this.currency});

  final WorkplacePayroll workplace;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final color = palette
        .categorical[workplace.company.colorIndex % palette.categorical.length];

    return Card(
      margin: const EdgeInsetsDirectional.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(width: 4, height: 32, color: color),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(workplace.company.name,
                          style: theme.textTheme.titleSmall),
                      Text(
                        '${ArabicPlural.days(workplace.attendedDays)} حضور · '
                        '${DateHelpers.formatDurationCompact(workplace.presenceMinutes)}',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: palette.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${workplace.net.toStringAsFixed(0)} $currency',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: palette.accent),
                ),
              ],
            ),
            const Divider(height: AppSpacing.xl),
            _Line(
                label: 'الأساسي',
                value: workplace.basic,
                currency: currency),
            if (workplace.overtime != 0)
              _Line(
                  label: 'الإضافي',
                  value: workplace.overtime,
                  currency: currency,
                  positive: true),
            if (workplace.adjustments != 0)
              _Line(
                  label: 'بدلات واستقطاعات',
                  value: workplace.adjustments,
                  currency: currency,
                  positive: workplace.adjustments > 0),
            if (workplace.deductions != 0)
              _Line(
                  label: 'عجز وغياب',
                  value: -workplace.deductions,
                  currency: currency),
            if (workplace.holidayOvertimeMinutes > 0 ||
                workplace.leaveDays > 0) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                [
                  if (workplace.holidayOvertimeMinutes > 0)
                    'منه ${DateHelpers.formatDurationCompact(workplace.holidayOvertimeMinutes)} '
                        'إضافي في عطلة',
                  if (workplace.leaveDays > 0)
                    '${ArabicPlural.days(workplace.leaveDays)} إجازة',
                ].join(' · '),
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: context.palette.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({
    required this.label,
    required this.value,
    required this.currency,
    this.positive,
  });

  final String label;
  final double value;
  final String currency;
  final bool? positive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final isPositive = positive ?? value >= 0;

    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodySmall)),
          Text(
            '${value.toStringAsFixed(0)} $currency',
            style: theme.textTheme.bodyMedium?.copyWith(
                color: isPositive ? palette.onSurface : palette.negative),
          ),
        ],
      ),
    );
  }
}

/// رؤى الشهر — ما يستحق أن يُقال عن الفرق بينه وبين ما قبله.
class _Insights extends ConsumerWidget {
  const _Insights({required this.year, required this.month});

  final int year;
  final int month;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync =
        ref.watch(personalInsightsProvider(year: year, month: month));

    // الصمت هو الحالة الطبيعية: شهر بلا فرق مادّي لا يستحق بطاقة فارغة
    // تقول «لا جديد».
    final insights = insightsAsync.value ?? const <PersonalInsight>[];
    if (insights.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'ما يستحق الانتباه'),
        for (final insight in insights) _InsightTile(insight: insight),
      ],
    );
  }
}

class _InsightTile extends StatelessWidget {
  const _InsightTile({required this.insight});

  final PersonalInsight insight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    final (color, icon) = switch (insight.tone) {
      InsightTone.positive => (palette.positive, Icons.trending_up_rounded),
      InsightTone.negative => (palette.negative, Icons.trending_down_rounded),
      InsightTone.neutral => (palette.info, Icons.lightbulb_outline_rounded),
    };

    return Card(
      margin: const EdgeInsetsDirectional.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Icon(icon, color: color, size: AppIconSize.md),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(insight.message, style: theme.textTheme.bodySmall),
            ),
          ],
        ),
      ),
    );
  }
}
