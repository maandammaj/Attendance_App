import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/design_tokens.dart';
import '../../../core/utils/biometric_auth.dart';
import '../../providers/reminder_provider.dart';
import 'widgets/lock_illustration.dart';

/// شاشة قفل التطبيق. تظهر فقط عند تفعيل `appLockEnabled`.
///
/// لا تسمح بالتجاوز إلا حين يكون التعذّر من الجهاز نفسه (لا مستشعر ولا قفل)،
/// وإلا لأصبح القفل زينة.
class BiometricLockScreen extends ConsumerStatefulWidget {
  const BiometricLockScreen({super.key, required this.onUnlocked});

  final VoidCallback onUnlocked;

  @override
  ConsumerState<BiometricLockScreen> createState() =>
      _BiometricLockScreenState();
}

class _BiometricLockScreenState extends ConsumerState<BiometricLockScreen> {
  final _auth = BiometricAuthService();

  bool _isChecking = false;
  BiometricResult? _lastResult;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _unlock());
  }

  Future<void> _unlock() async {
    if (_isChecking) return;
    setState(() => _isChecking = true);

    final settings = await ref.read(reminderSettingsProvider.future);
    final result = await _auth.authenticate(
      reason: 'افتح التطبيق بالتحقق من هويتك',
      allowDeviceCredential: settings.allowDeviceCredential,
    );

    if (!mounted) return;
    setState(() {
      _isChecking = false;
      _lastResult = result;
    });

    // جهاز بلا وسيلة تحقق لا يمكن أن يبقى مقفلاً للأبد.
    if (result.isSuccess || result.isDeviceLimitation) widget.onUnlocked();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final message = _lastResult?.message;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LockIllustration(),
              const SizedBox(height: 36),
              Text('التطبيق مقفل', style: theme.textTheme.headlineSmall)
                  .animate()
                  .fadeIn(delay: AppDurations.medium),
              const SizedBox(height: 8),
              Text(
                'بياناتك المالية محمية. أكّد هويتك للمتابعة.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ).animate().fadeIn(delay: AppDurations.slow),
              if (message != null && !_isChecking) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer
                        .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(AppRadius.field),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          size: 18, color: theme.colorScheme.error),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(message,
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onErrorContainer)),
                      ),
                    ],
                  ),
                ).animate().shake(hz: 3, offset: const Offset(3, 0)),
              ],
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isChecking ? null : _unlock,
                  icon: _isChecking
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.fingerprint_rounded),
                  label: Text(_isChecking ? 'جارٍ التحقق…' : 'فتح التطبيق'),
                ),
              ).animate().fadeIn(delay: AppDurations.slow).slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}
