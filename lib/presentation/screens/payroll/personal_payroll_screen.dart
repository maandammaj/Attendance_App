import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/design_tokens.dart';
import '../../../core/utils/date_helpers.dart';
import '../../../domain/entities/payroll_entity.dart';
import '../../providers/payroll_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/state_switcher.dart';

/// دخل المستخدم من كل جهاته في شهر.
class PersonalPayrollScreen extends ConsumerWidget {
  const PersonalPayrollScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final payrollAsync =
        ref.watch(personalPayrollProvider(year: now.year, month: now.month));
    final currency = ref.watch(profileProvider).value?.currency ??
        AppConstants.defaultCurrency;

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
              const SizedBox(height: AppSpacing.xl),
              SectionHeader(
                title: 'من أين جاء',
                subtitle: DateHelpers.arabicMonths[now.month - 1],
              ),
              for (final workplace in payroll.workplaces)
                _WorkplaceCard(workplace: workplace, currency: currency),
              if (payroll.workplaces.length > 1) ...[
                const SizedBox(height: AppSpacing.md),
                _HourlyInsight(payroll: payroll, currency: currency),
              ],
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
            'إجمالي دخلك من ${payroll.workplaces.length} جهات',
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
                        '${workplace.attendedDays} يوم حضور · '
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

/// أي جهة تُعيد أكثر مقابل الساعة — قرارٌ لا يظهر من الصافي وحده.
class _HourlyInsight extends StatelessWidget {
  const _HourlyInsight({required this.payroll, required this.currency});

  final PersonalPayroll payroll;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final best = payroll.bestHourlyReturn;
    final top = payroll.topEarner;
    if (best == null || top == null || best.presenceMinutes == 0) {
      return const SizedBox.shrink();
    }

    final sameWorkplace = best.company.id == top.company.id;

    return Card(
      color: palette.info.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Icon(Icons.lightbulb_outline_rounded,
                color: palette.info, size: AppIconSize.md),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                sameWorkplace
                    ? '«${best.company.name}» الأعلى دخلاً والأعلى عائداً للساعة '
                        '(${best.netPerHour.toStringAsFixed(0)} $currency لكل ساعة).'
                    : '«${top.company.name}» تعطيك دخلاً أكبر، لكن '
                        '«${best.company.name}» تعطيك ${best.netPerHour.toStringAsFixed(0)} $currency '
                        'لكل ساعة مقابل ${top.netPerHour.toStringAsFixed(0)}.',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
