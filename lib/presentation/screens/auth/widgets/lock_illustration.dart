import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/design_tokens.dart';

/// أيقونة بصمة داخل حلقتين نابضتين — تشير إلى أن التطبيق ينتظر التحقق.
class LockIllustration extends StatelessWidget {
  const LockIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = palette.primary;

    return SizedBox(
      width: 190,
      height: 190,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (final scale in [1.0, 0.78])
            Container(
              width: 190 * scale,
              height: 190 * scale,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.06),
              ),
            )
                .animate(onPlay: (c) => context.prefersReducedMotion ? c.stop() : c.repeat(reverse: true))
                .scaleXY(
                  begin: 1,
                  end: 1.06,
                  duration: Duration(milliseconds: (1800 * scale).round()),
                  curve: Curves.easeInOut,
                ),
          Container(
            width: 108,
            height: 108,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: AppPalette.brandGradient,
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
              ),
              boxShadow: AppElevation.raised(palette),
            ),
            child: const Icon(Icons.fingerprint_rounded,
                size: 56, color: Colors.white),
          )
              .animate()
              .scaleXY(
                  begin: 0.6,
                  end: 1,
                  duration: AppDurations.slow,
                  curve: AppCurves.emphasized)
              .fadeIn(),
        ],
      ),
    );
  }
}
