import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/design_tokens.dart';
import '../../providers/profile_provider.dart';
import 'setup_flow_screen.dart';

/// يعترض جذر التطبيق: لا شاشة تُعرض قبل وجود ملف شخصي.
///
/// يراقب `profileProvider` بدل تمرير نتيجة الحفظ، فحفظ الملف من أي مكان
/// (الإعداد أو استعادة نسخة) يفتح التطبيق تلقائياً.
class SetupGate extends ConsumerWidget {
  const SetupGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return AnimatedSwitcher(
      duration: AppDurations.medium,
      switchInCurve: AppCurves.emphasized,
      child: profile.when(
        // أثناء أول قراءة نعرض فراغاً بلون الخلفية لا مؤشراً: القراءة من
        // قاعدة محلية أسرع من أن يستقر المؤشر، فيومض ولا يفيد.
        loading: () => const _Blank(key: ValueKey('loading')),
        error: (error, _) => _SetupError(
          key: const ValueKey('error'),
          message: '$error',
          onRetry: () => ref.invalidate(profileProvider),
        ),
        data: (data) => data == null
            ? const SetupFlowScreen(key: ValueKey('setup'))
            : KeyedSubtree(key: const ValueKey('app'), child: child),
      ),
    );
  }
}

class _Blank extends StatelessWidget {
  const _Blank({super.key});

  @override
  Widget build(BuildContext context) =>
      ColoredBox(color: context.palette.background);
}

class _SetupError extends StatelessWidget {
  const _SetupError({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 48, color: palette.negative),
              const SizedBox(height: AppSpacing.lg),
              Text('تعذّر فتح بياناتك', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: palette.onSurfaceVariant)),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(onPressed: onRetry, child: const Text('إعادة المحاولة')),
            ],
          ),
        ),
      ),
    );
  }
}
