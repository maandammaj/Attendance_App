import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/design_tokens.dart';

/// نقطة نابضة تدل على حالة حيّة (جلسة دوام مفتوحة).
///
/// الحركة لا نهائية عمداً: وجودها هو الإشارة، وتوقفها يعني أن الجلسة أُغلقت.
class PulsingDot extends StatelessWidget {
  const PulsingDot({super.key, required this.color, this.size = 10});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    // الحلقة المتكرّرة تُستبدل بحلقة ثابتة: الإشارة تبقى، والحركة تزول.
    if (context.prefersReducedMotion) {
      return SizedBox(
        width: size * 2.4,
        height: size * 2.4,
        child: Center(
          child: Container(
            width: size * 1.6,
            height: size * 1.6,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.3),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: size * 2.4,
      height: size * 2.4,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size * 2.4,
            height: size * 2.4,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.35),
              shape: BoxShape.circle,
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .scaleXY(
                begin: 0.55,
                end: 1,
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOut,
              )
              .fadeOut(duration: const Duration(milliseconds: 1200)),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }
}
