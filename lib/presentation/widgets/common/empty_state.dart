import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/design_tokens.dart';

/// حالة فراغ موحّدة: أيقونة، سبب، وإجراء يخرج المستخدم منها.
///
/// الإجراء ليس زينة — شاشة فارغة بلا مخرج تترك المستخدم أمام سطر رمادي
/// لا يقول له ماذا يفعل.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = _Content(
      icon: icon,
      title: title,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
      theme: theme,
    );

    // تُتخطّى السلسلة كلها ولا تُعطَّل بـ `target: 0`: بداية `fadeIn` شفافية
    // صفر، فإيقاف السلسلة عند بدايتها يبني الحالة ويتركها غير مرئية.
    if (context.prefersReducedMotion) return Center(child: content);

    return Center(
      child: content.animate().fadeIn(duration: AppDurations.medium),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    required this.theme,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final badge = Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: AppIconSize.xl, color: theme.colorScheme.primary),
    );

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          context.prefersReducedMotion
              ? badge
              : badge.animate().scaleXY(
                    begin: 0.7,
                    end: 1,
                    duration: AppDurations.slow,
                    curve: AppCurves.emphasized,
                  ),
          const SizedBox(height: AppSpacing.xl),
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.xl),
            FilledButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}
