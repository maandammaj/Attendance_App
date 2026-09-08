import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/design_tokens.dart';
import '../../providers/reminder_provider.dart';
import 'biometric_lock_screen.dart';

/// يعترض جذر التطبيق: يعرض شاشة القفل حين يكون `appLockEnabled` مفعّلاً،
/// ويعيد القفل عند عودة التطبيق من الخلفية.
class AppLockGate extends ConsumerStatefulWidget {
  const AppLockGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate>
    with WidgetsBindingObserver {
  bool _isUnlocked = false;
  DateTime? _backgroundedAt;

  /// مهلة سماح قصيرة: التبديل السريع لتطبيق آخر لا ينبغي أن يعيد القفل.
  static const _graceperiod = Duration(seconds: 30);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _backgroundedAt ??= DateTime.now();
      return;
    }
    if (state == AppLifecycleState.resumed) {
      final since = _backgroundedAt;
      _backgroundedAt = null;
      if (since != null && DateTime.now().difference(since) > _graceperiod) {
        setState(() => _isUnlocked = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(reminderSettingsProvider).value;

    // ريثما تُقرأ الإعدادات لا نعرض المحتوى، حتى لا يومض قبل القفل.
    if (settings == null) {
      return const ColoredBox(
        color: Colors.transparent,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final needsLock = settings.appLockEnabled && !_isUnlocked;

    return AnimatedSwitcher(
      duration: AppDurations.medium,
      switchInCurve: AppCurves.emphasized,
      child: needsLock
          ? BiometricLockScreen(
              key: const ValueKey('lock'),
              onUnlocked: () => setState(() => _isUnlocked = true),
            )
          : KeyedSubtree(
              key: const ValueKey('app'),
              child: widget.child,
            ),
    );
  }
}
