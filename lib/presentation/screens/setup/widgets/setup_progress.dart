import 'package:flutter/material.dart';

import '../../../../core/constants/design_tokens.dart';

/// شريط تقدّم الإعداد مع زر رجوع يظهر بعد الخطوة الأولى.
class SetupProgress extends StatelessWidget {
  const SetupProgress({
    super.key,
    required this.step,
    required this.total,
    required this.onBack,
  });

  final int step;
  final int total;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
          AppSpacing.sm, AppSpacing.sm, AppSpacing.lg, AppSpacing.sm),
      child: Row(
        children: [
          AnimatedOpacity(
            opacity: step == 0 ? 0 : 1,
            duration: AppDurations.fast,
            child: IconButton(
              onPressed: step == 0 ? null : onBack,
              icon: const Icon(Icons.arrow_forward_rounded),
              tooltip: 'رجوع',
            ),
          ),
          Expanded(
            child: Row(
              children: [
                for (int i = 0; i < total; i++)
                  Expanded(
                    child: AnimatedContainer(
                      duration: AppDurations.medium,
                      curve: AppCurves.emphasized,
                      height: 4,
                      margin: const EdgeInsetsDirectional.only(end: 6),
                      decoration: BoxDecoration(
                        color: i <= step
                            ? palette.primary
                            : palette.primary.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text('${step + 1}/$total', style: theme.textTheme.labelSmall),
        ],
      ),
    );
  }
}
