import 'package:flutter/material.dart';

import '../../../../core/constants/design_tokens.dart';
import '../../../../core/constants/theme.dart';
import '../../../providers/dashboard_provider.dart';

/// مساهمات موقّعة في الراتب: ما أُضيف وما خُصم.
///
/// أعمدة ثنائية الاتجاه حول خط صفر، لا رسم دائري: الدائري يمثّل أجزاء من
/// كلّ موجب، فحشر القيم السالبة فيه بـ`abs()` يقلب معناها — الخصم يظهر
/// كمساهمة. القطبان دافئ/بارد بمنتصف محايد كما تفرض قواعد التصوير.
class SalaryCompositionChart extends StatelessWidget {
  const SalaryCompositionChart({super.key, required this.data});

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    final rows = <(String, double)>[
      ('الأساسي', data.baseSalary),
      ('الإضافي', data.totalOvertimeValue),
      ('بدلات وخصومات', data.totalAdjustments),
      ('خصم العجز', -data.totalDeficitValue),
      ('سداد ديون', -data.totalDebtPayments),
      ('مصروفات', -data.totalTransactionsExpenses),
    ].where((row) => row.$2.abs() > 0.01).toList();

    if (rows.isEmpty) {
      return Text('لا بيانات لهذا الشهر بعد',
          style: theme.textTheme.bodySmall
              ?.copyWith(color: palette.onSurfaceVariant));
    }

    // المقياس من أكبر قيمة مطلقة، فتُقارن الأعمدة ببعضها لا كلٌّ بنفسه.
    final scale = rows
        .map((row) => row.$2.abs())
        .reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            for (int i = 0; i < rows.length; i++) ...[
              _Row(
                label: rows[i].$1,
                value: rows[i].$2,
                scale: scale,
                currency: data.currency,
              ),
              if (i < rows.length - 1) const SizedBox(height: AppSpacing.md),
            ],
            const Divider(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: Text('الصافي', style: theme.textTheme.titleSmall),
                ),
                Text(
                  '${data.netSalary.toStringAsFixed(0)} ${data.currency}',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(
                        color: data.netSalary >= 0
                            ? palette.accent
                            : palette.negative,
                      )
                      .merge(tabularFigures),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.value,
    required this.scale,
    required this.currency,
  });

  final String label;
  final double value;
  final double scale;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final isPositive = value >= 0;
    final color = isPositive ? palette.positive : palette.negative;
    final fraction = scale <= 0 ? 0.0 : (value.abs() / scale).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // الاتجاه مُرمَّز بالأيقونة والإشارة أيضاً، لا باللون وحده.
            Icon(
              isPositive ? Icons.add_rounded : Icons.remove_rounded,
              size: AppIconSize.sm,
              color: color,
            ),
            const SizedBox(width: 6),
            Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
            Text(
              '${value.abs().toStringAsFixed(0)} $currency',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: palette.onSurface)
                  .merge(tabularFigures),
            ),
          ],
        ),
        const SizedBox(height: 6),
        // خط الصفر في المنتصف: الموجب يمتد للبداية، السالب للنهاية.
        Row(
          children: [
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: _Bar(
                  fraction: isPositive ? fraction : 0,
                  color: palette.positive,
                ),
              ),
            ),
            Container(
              width: 1.5,
              height: 12,
              color: palette.divergingNeutral,
            ),
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: _Bar(
                  fraction: isPositive ? 0 : fraction,
                  color: palette.negative,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.fraction, required this.color});

  final double fraction;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: fraction),
        duration: context.motion(AppDurations.slow),
        curve: AppCurves.emphasized,
        builder: (context, value, _) => Container(
          height: 8,
          width: constraints.maxWidth * value,
          decoration: BoxDecoration(
            color: color,
            // نهاية مستديرة عند طرف البيانات فقط؛ الطرف الملتصق بخط الصفر
            // يبقى حاداً حتى لا يبدو منفصلاً عنه.
            borderRadius: const BorderRadiusDirectional.horizontal(
              start: Radius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}
