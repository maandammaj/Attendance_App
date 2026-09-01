import 'package:flutter/material.dart';

import '../../../../core/constants/design_tokens.dart';
import '../../../../core/constants/theme.dart';
import '../../../../core/utils/date_helpers.dart';
import '../../../../domain/usecases/reports/compare_companies_usecase.dart';
import '../../../widgets/analytics/analytics_card.dart';

/// مقارنة الجهات بالعائد الفعلي للساعة.
///
/// الراتب وحده يضلّل: جهة براتب ضِعف الأخرى قد تأخذ ثلاثة أضعاف الوقت.
/// القسمة على ساعات الحضور هي ما يجعل الرقمين قابلين للمقارنة.
class CompanyComparison extends StatelessWidget {
  const CompanyComparison({
    super.key,
    required this.entries,
    required this.currency,
  });

  final List<CompanyPerformance> entries;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    final withHours =
        entries.where((entry) => entry.presenceMinutes > 0).toList();
    if (withHours.isEmpty) {
      return AnalyticsCard(
        title: 'مقارنة الجهات',
        subtitle: 'لا ساعات مسجّلة في هذه الفترة',
        child: Text(
          'سجّل دواماً في جهتين أو أكثر لتظهر المقارنة.',
          style: theme.textTheme.bodySmall
              ?.copyWith(color: palette.onSurfaceVariant),
        ),
      );
    }

    final best = withHours.first.effectiveHourlyRate;

    return AnalyticsCard(
      title: 'مقارنة الجهات',
      subtitle: 'العائد الفعلي لكل ساعة حضور',
      child: Column(
        children: [
          for (int i = 0; i < withHours.length; i++) ...[
            _Row(
              entry: withHours[i],
              fraction: best <= 0
                  ? 0
                  : withHours[i].effectiveHourlyRate / best,
              currency: currency,
              isBest: i == 0 && withHours.length > 1,
            ),
            if (i < withHours.length - 1)
              const SizedBox(height: AppSpacing.lg),
          ],
          if (withHours.length > 1) ...[
            const Divider(height: AppSpacing.xl),
            _Verdict(entries: withHours, currency: currency),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.entry,
    required this.fraction,
    required this.currency,
    required this.isBest,
  });

  final CompanyPerformance entry;
  final double fraction;
  final String currency;
  final bool isBest;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final color = palette
        .categorical[entry.company.colorIndex % palette.categorical.length];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(3)),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(entry.company.name,
                  style: theme.textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis),
            ),
            if (isBest)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
                child: Icon(Icons.workspace_premium_outlined,
                    size: AppIconSize.sm, color: palette.accent),
              ),
            Text(
              '${entry.effectiveHourlyRate.toStringAsFixed(1)} $currency/ساعة',
              style: theme.textTheme.titleSmall
                  ?.copyWith(color: palette.onSurface)
                  .merge(tabularFigures),
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
        const SizedBox(height: 6),
        Text(
          '${DateHelpers.formatDurationCompact(entry.presenceMinutes)} '
          'في ${entry.attendedDays} يوم · '
          'مستحق ${entry.earned.toStringAsFixed(0)} $currency',
          style: theme.textTheme.bodySmall
              ?.copyWith(color: palette.onSurfaceVariant),
        ),
      ],
    );
  }
}

/// الخلاصة بجملة واحدة — الرقم وحده لا يقول ماذا يعني.
class _Verdict extends StatelessWidget {
  const _Verdict({required this.entries, required this.currency});

  final List<CompanyPerformance> entries;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    final best = entries.first;
    final worst = entries.last;
    final gap = best.effectiveHourlyRate - worst.effectiveHourlyRate;
    final ratio = worst.effectiveHourlyRate <= 0
        ? 0.0
        : best.effectiveHourlyRate / worst.effectiveHourlyRate;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.lightbulb_outline_rounded,
            size: AppIconSize.md, color: palette.accent),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            'ساعتك في «${best.company.name}» تعادل '
            '${ratio.toStringAsFixed(1)}× ساعتك في «${worst.company.name}» '
            '— بفارق ${gap.toStringAsFixed(1)} $currency لكل ساعة.',
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
