import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/design_tokens.dart';

/// يوحّد الحالات الثلاث لأي `AsyncValue`: تحميل، خطأ، بيانات.
///
/// يستبدل المؤشّرات الدائرية المتناثرة بهيكل عظمي: المؤشّر يقفز في مكان
/// المحتوى ثم يختفي، فتتحرّك الصفحة تحت الإصبع؛ الهيكل يحجز المساحة نفسها.
class StateSwitcher<T> extends StatelessWidget {
  const StateSwitcher({
    super.key,
    required this.value,
    required this.builder,
    this.onRetry,
    this.skeletonHeight = 160,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) builder;
  final VoidCallback? onRetry;
  final double skeletonHeight;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppDurations.medium,
      switchInCurve: AppCurves.emphasized,
      // بلا مفاتيح صريحة: AnimatedSwitcher يميّز الحالات بنوع الويدجت،
      // والمفتاح الثابت كان يتصادم مع طفل خارج لم تنتهِ حركته بعد
      // (تحميل ← بيانات ← تحميل سريعاً) فيرمي "Duplicate keys found".
      child: value.when(
        data: builder,
        loading: () => Skeleton(height: skeletonHeight),
        error: (error, _) => _ErrorView(
          message: '$error',
          onRetry: onRetry,
        ),
      ),
    );
  }
}

/// مستطيل بلون السطح البديل مع نبضة خفيفة.
///
/// النبضة عبر [AnimatedOpacity] لا حزمة تحميل خارجية: أخفّ، وتحترم إعداد
/// تقليل الحركة في النظام تلقائياً لأنها تتوقف مع `TickerMode`.
class Skeleton extends StatefulWidget {
  const Skeleton({super.key, this.height = 160, this.width});

  final double height;
  final double? width;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // النبض يتوقف عند طلب تقليل الحركة؛ الهيكل يظل يحجز المساحة وهو ساكن.
    if (context.prefersReducedMotion) {
      _controller.stop();
      _controller.value = 1;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return FadeTransition(
      opacity: Tween<double>(begin: 0.45, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: Container(
        height: widget.height,
        width: widget.width,
        margin: const EdgeInsetsDirectional.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: palette.surfaceAlt,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: palette.negative.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: palette.negative.withValues(alpha: 0.28)),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline_rounded,
              color: palette.negative, size: AppIconSize.lg),
          const SizedBox(height: AppSpacing.md),
          Text('تعذّر تحميل هذا القسم', style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: palette.onSurfaceVariant),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
                onPressed: onRetry, child: const Text('إعادة المحاولة')),
          ],
        ],
      ),
    );
  }
}
