import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/design_tokens.dart';

/// دخول متدرّج لعنصر في قائمة: تلاشٍ مع صعود بسيط، بتأخير حسب موقعه.
///
/// يُستخدم بدل تكرار سلسلة `.animate().fadeIn().slideY()` في كل شاشة،
/// حتى يبقى إيقاع الحركة واحداً في التطبيق كله.
class AnimatedEntrance extends StatelessWidget {
  const AnimatedEntrance({
    super.key,
    required this.child,
    this.index = 0,
    this.slide = 0.08,
  });

  final Widget child;
  final int index;

  /// مقدار الصعود كنسبة من ارتفاع العنصر.
  final double slide;

  @override
  Widget build(BuildContext context) {
    if (context.prefersReducedMotion) return child;

    // بعد العنصر العاشر يصبح التأخير التراكمي ملحوظاً، فنثبّته.
    final delay = AppDurations.stagger * (index > 10 ? 10 : index);
    return child
        .animate()
        .fadeIn(duration: AppDurations.medium, delay: delay)
        .slideY(
          begin: slide,
          end: 0,
          duration: AppDurations.medium,
          delay: delay,
          curve: AppCurves.emphasized,
        );
  }
}

/// يغلّف قائمة كاملة فيمنح كل عنصر [AnimatedEntrance] بترتيبه.
class StaggeredColumn extends StatelessWidget {
  const StaggeredColumn({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  });

  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        for (int i = 0; i < children.length; i++)
          AnimatedEntrance(index: i, child: children[i]),
      ],
    );
  }
}
