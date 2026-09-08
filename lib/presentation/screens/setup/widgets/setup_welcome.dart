import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/design_tokens.dart';

/// الخطوة الأولى: تشرح لماذا الإعداد إلزامي قبل أن تطلب أي بيانات.
class SetupWelcome extends StatelessWidget {
  const SetupWelcome({super.key});

  static const _points = <(IconData, String, String)>[
    (
      Icons.fingerprint_rounded,
      'دوام موثّق',
      'سجّل حضورك وانصرافك بالبصمة، وعدّة جلسات في اليوم الواحد',
    ),
    (
      Icons.payments_outlined,
      'راتب محسوب لحظياً',
      'ساعاتك تتحوّل إلى مبلغ: الأساسي والإضافي والعجز',
    ),
    (
      Icons.insights_rounded,
      'تقارير تُصدَّر',
      'رسوم بيانية وكشف راتب PDF قابل للطباعة والمشاركة',
    ),
    (
      Icons.lock_outline_rounded,
      'بياناتك عندك',
      'كل شيء محفوظ على جهازك — بلا خادم وبلا حساب',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.card),
            gradient: LinearGradient(
              colors: AppPalette.brandGradient,
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
            ),
          ),
          child: const Icon(Icons.access_time_filled_rounded,
              size: 44, color: Colors.white),
        )
            .animate()
            .scaleXY(
                begin: 0.7,
                end: 1,
                duration: AppDurations.slow,
                curve: AppCurves.emphasized)
            .fadeIn(),
        const SizedBox(height: AppSpacing.xl),
        Text('لنجهّز حسابك', style: theme.textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'ثلاث خطوات قصيرة. كل حساب في التطبيق يقوم على راتبك وجدول دوامك، '
          'فلا يمكن البدء بدونهما.',
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: palette.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.xl),
        for (int i = 0; i < _points.length; i++)
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: palette.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(AppRadius.field),
                  ),
                  child: Icon(_points[i].$1,
                      color: palette.primary, size: AppIconSize.md),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_points[i].$2, style: theme.textTheme.titleSmall),
                      Text(
                        _points[i].$3,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: palette.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(
                  delay: AppDurations.stagger * (i + 2),
                  duration: AppDurations.medium)
              .slideY(begin: 0.15, end: 0, curve: AppCurves.emphasized),
      ],
    );
  }
}
