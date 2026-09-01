// presentation/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import '../providers/profile_provider.dart';

final localAuthProvider = Provider<LocalAuthentication>((ref) {
  return LocalAuthentication();
});

final biometricAuthProvider = FutureProvider.family<bool, String>((ref, reason) async {
  final auth = ref.read(localAuthProvider);
  final canCheck = await auth.canCheckBiometrics;

  if (!canCheck) return false;

  return await auth.authenticate(
    localizedReason: reason,
    authMessages: const [
      // AndroidAuthMessages(
      //   signInTitle: 'التأكد من هويتك',
      //   cancelButton: 'إلغاء',
      //   biometricHint: 'استخدم البصمة للتأكد',
      // ),
      // IOSAuthMessages(
      //   cancelButton: 'إلغاء',
      //   goToSettingsButton: 'الإعدادات',
      //   goToSettingsDescription: 'يرجى إعداد البصمة في إعدادات الجهاز',
      // ),
    ],
    options: const AuthenticationOptions(
      biometricOnly: true,
      stickyAuth: true,
    ),
  );
});