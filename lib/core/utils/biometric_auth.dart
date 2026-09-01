import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
// import 'package:local_auth_ios/local_auth_ios.dart';
import '../errors/exceptions.dart';

class BiometricAuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> get isAvailable async {
    final canCheck = await _auth.canCheckBiometrics;
    final isDeviceSupported = await _auth.isDeviceSupported();
    return canCheck && isDeviceSupported;
  }

  Future<List<BiometricType>> get availableBiometrics async {
    return await _auth.getAvailableBiometrics();
  }

  Future<bool> authenticate({
    required String localizedReason,
    bool useErrorDialogs = true,
    bool stickyAuth = true,
    bool biometricOnly = true,
  }) async {
    try {
      return await _auth.authenticate(
        localizedReason: localizedReason,
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'التأكد من هويتك',
            cancelButton: 'إلغاء',
            biometricHint: 'استخدم البصمة للتأكد',
            biometricNotRecognized: 'لم يتم التعرف على البصمة، حاول مرة أخرى',
            biometricRequiredTitle: 'البصمة مطلوبة',
            deviceCredentialsRequiredTitle: 'بيانات الاعتماد مطلوبة',
            deviceCredentialsSetupDescription: 'يرجى إعداد بيانات الاعتماد',
            goToSettingsButton: 'الإعدادات',
            goToSettingsDescription: 'يرجى إعداد البصمة في إعدادات الجهاز',
          ),
          // IOSAuthMessages(
          //   cancelButton: 'إلغاء',
          //   goToSettingsButton: 'الإعدادات',
          //   goToSettingsDescription: 'يرجى إعداد Face ID في إعدادات الجهاز',
          //   lockOut: 'يرجى إعادة تمكين Face ID',
          // ),
        ],
        options: AuthenticationOptions(
          useErrorDialogs: useErrorDialogs,
          stickyAuth: stickyAuth,
          biometricOnly: biometricOnly,
        ),
      );
    } catch (e) {
      throw BiometricAuthException(e.toString());
    }
  }

  Future<bool> stopAuthentication() async {
    return await _auth.stopAuthentication();
  }
}