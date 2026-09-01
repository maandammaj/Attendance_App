import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/biometric_auth.dart';

class BiometricLockScreen extends ConsumerStatefulWidget {
  const BiometricLockScreen({super.key});

  @override
  ConsumerState<BiometricLockScreen> createState() => _BiometricLockScreenState();
}

class _BiometricLockScreenState extends ConsumerState<BiometricLockScreen> {
  bool _isAuthenticating = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    setState(() {
      _isAuthenticating = true;
      _error = null;
    });

    final auth = BiometricAuthService();
    final available = await auth.isAvailable;

    if (!available) {
      // إذا لا يوجد بصمة، انتقل مباشرة
      _navigateToHome();
      return;
    }

    final result = await auth.authenticate(
      localizedReason: 'افتح التطبيق ببصمة إصبعك',
    );

    if (result && mounted) {
      _navigateToHome();
    } else {
      setState(() {
        _isAuthenticating = false;
        _error = 'فشل التحقق. حاول مرة أخرى.';
      });
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fingerprint,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 32),
            Text(
              'تطبيق إدارة الدوام والميزانية',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            if (_isAuthenticating)
              const CircularProgressIndicator()
            else ...[
              if (_error != null)
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _authenticate,
                icon: const Icon(Icons.fingerprint),
                label: const Text('المصادقة بالبصمة'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}