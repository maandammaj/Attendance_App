import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/design_tokens.dart';

/// زر الحضور/الانصراف: يبدّل شكله ولونه حسب وجود جلسة مفتوحة.
///
/// التبديل عبر [AnimatedSwitcher] لا ببناء زرّين، فيبقى مركز اللمس ثابتاً
/// ولا يقفز الزر أثناء التغيير.
class AttendanceFab extends StatelessWidget {
  const AttendanceFab({
    super.key,
    required this.isSessionOpen,
    required this.isBusy,
    required this.onPressed,
  });

  final bool isSessionOpen;
  final bool isBusy;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final colors =
        isSessionOpen ? AppPalette.activeGradient : AppPalette.brandGradient;

    return Semantics(
      button: true,
      label: isSessionOpen ? 'تسجيل الانصراف' : 'تسجيل الحضور',
      child: GestureDetector(
        onTap: isBusy ? null : onPressed,
        child: AnimatedContainer(
          duration: AppDurations.medium,
          curve: AppCurves.emphasized,
          height: 64,
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            gradient: LinearGradient(
              colors: isBusy
                  ? [palette.onSurfaceVariant, palette.onSurfaceVariant]
                  : colors,
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
            ),
            boxShadow: isBusy ? const [] : AppElevation.floating(palette),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 26,
                height: 26,
                child: isBusy
                    ? const CircularProgressIndicator(
                        strokeWidth: 2.4, color: Colors.white)
                    : AnimatedSwitcher(
                        duration: AppDurations.fast,
                        transitionBuilder: (child, animation) => ScaleTransition(
                          scale: animation,
                          child: FadeTransition(
                              opacity: animation, child: child),
                        ),
                        child: Icon(
                          isSessionOpen
                              ? Icons.logout_rounded
                              : Icons.fingerprint_rounded,
                          key: ValueKey(isSessionOpen),
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
              ),
              const SizedBox(width: 10),
              AnimatedSize(
                duration: AppDurations.medium,
                curve: AppCurves.emphasized,
                child: Text(
                  isBusy
                      ? 'جارٍ التحقق…'
                      : (isSessionOpen ? 'انصراف' : 'حضور'),
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(target: (isSessionOpen && !context.prefersReducedMotion) ? 1 : 0)
        .shimmer(
          duration: const Duration(milliseconds: 1400),
          delay: const Duration(milliseconds: 400),
        );
  }
}
