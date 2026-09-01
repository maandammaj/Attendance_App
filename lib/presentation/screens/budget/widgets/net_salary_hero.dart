import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/design_tokens.dart';
import '../../../../core/constants/theme.dart';
import '../../../providers/dashboard_provider.dart';

/// الرقم الوحيد الذي يهم: ما تبقّى من الشهر.
///
/// رقم مفرد لا رسم — قاعدة تصوير البيانات: حين تكون القصة رقماً واحداً،
/// ثماني شرائح ملوّنة تُخفيه بدل أن تُظهره.
class NetSalaryHero extends StatelessWidget {
  const NetSalaryHero({super.key, required this.data});

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final isPositive = data.netSalary >= 0;

    // نسبة ما تبقّى من إجمالي المستحق — تقيس مدى استهلاك الشهر.
    final gross = data.baseSalary +
        data.totalOvertimeValue +
        data.totalAdjustments;
    final remaining =
        gross <= 0 ? 0.0 : (data.netSalary / gross).clamp(0.0, 1.0);

    final card = Container(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isPositive ? 'المتبقي لك هذا الشهر' : 'تجاوزت دخلك هذا الشهر',
            style: theme.textTheme.titleSmall
                ?.copyWith(color: Colors.white.withValues(alpha: 0.88)),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: data.netSalary.abs()),
                    duration: context.motion(AppDurations.slow),
                    curve: AppCurves.emphasized,
                    builder: (context, value, _) => Text(
                      value.toStringAsFixed(0),
                      style: theme.textTheme.displayLarge
                          ?.copyWith(
                            color: isPositive
                                ? palette.accentOnBrand
                                : palette.negative,
                          )
                          .merge(tabularFigures),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                data.currency,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: (isPositive ? palette.accentOnBrand : palette.negative)
                      .withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: remaining.toDouble()),
              duration: context.motion(AppDurations.slow),
              curve: AppCurves.emphasized,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 6,
                color: palette.accentOnBrand,
                backgroundColor: Colors.white.withValues(alpha: 0.18),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'من إجمالي مستحق ${gross.toStringAsFixed(0)} ${data.currency}',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: Colors.white.withValues(alpha: 0.62)),
          ),
        ],
      ),
    );

    // الحركة تُتخطّى بالكامل لا تُشغَّل نحو بدايتها: تمرير target صفر يُبقي
    // fadeIn عند شفافية صفر، فتختفي البطاقة بدل أن تظهر ساكنة.
    if (context.prefersReducedMotion) return card;

    return card.animate().fadeIn(duration: AppDurations.medium).slideY(
          begin: 0.05,
          end: 0,
          duration: AppDurations.medium,
          curve: AppCurves.emphasized,
        );
  }
}
