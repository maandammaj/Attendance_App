import 'dart:developer' as developer;

import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

/// نتيجة محاولة تحقق، مفصّلة بما يكفي ليقرر المستدعي: يمضي، أم يمنع،
/// أم يوجّه المستخدم لإعدادات الجهاز.
enum BiometricOutcome {
  /// تحقّق ناجح بالبصمة أو بقفل الجهاز.
  success,

  /// المستخدم ألغى أو فشل التعرّف.
  failed,

  /// الجهاز لا يملك عتاد بصمة أصلاً (محاكي، سطح مكتب).
  unavailable,

  /// العتاد موجود لكن لا توجد بصمة مسجَّلة في النظام.
  notEnrolled,

  /// النظام أقفل التحقق مؤقتاً بعد محاولات فاشلة متكررة.
  lockedOut,
}

class BiometricResult {
  const BiometricResult(this.outcome, {this.message});

  final BiometricOutcome outcome;
  final String? message;

  bool get isSuccess => outcome == BiometricOutcome.success;

  /// هل التعذّر سببه الجهاز لا المستخدم؟ عندها يجوز المتابعة دون تحقق
  /// إن لم يكن التحقق إلزامياً في الإعدادات.
  bool get isDeviceLimitation =>
      outcome == BiometricOutcome.unavailable ||
      outcome == BiometricOutcome.notEnrolled;
}

class BiometricCapability {
  const BiometricCapability({
    required this.isSupported,
    required this.hasEnrolled,
    required this.types,
    this.hasDeviceCredential = false,
  });

  /// هل العتاد موجود ومدعوم؟
  final bool isSupported;

  /// هل سجّل المستخدم بصمة/وجهاً في إعدادات النظام؟
  final bool hasEnrolled;

  final List<BiometricType> types;

  /// هل على الجهاز قفل شاشة (رمز أو نمط) يصلح بديلاً عند غياب البصمة؟
  final bool hasDeviceCredential;

  /// بصمة/وجه مسجَّل فعلاً وجاهز للاستخدام.
  bool get isReady => isSupported && hasEnrolled;

  /// وصف عربي لما هو متاح فعلاً على هذا الجهاز.
  String get label {
    if (!isSupported) return 'غير مدعوم على هذا الجهاز';
    if (!hasEnrolled) return 'لا توجد بصمة مسجّلة في إعدادات الجهاز';
    if (types.contains(BiometricType.face)) return 'التعرف على الوجه';
    if (types.contains(BiometricType.fingerprint)) return 'بصمة الإصبع';
    if (types.contains(BiometricType.iris)) return 'بصمة العين';
    return 'قفل الجهاز';
  }
}

class BiometricAuthService {
  BiometricAuthService({LocalAuthentication? auth})
      : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  Future<BiometricCapability> capability() async {
    try {
      // isDeviceSupported يصدق حين يوجد أي قفل شاشة، وcanCheckBiometrics
      // حين يوجد عتاد حيوي — الفصل بينهما هو ما يميّز البصمة عن الرمز.
      final hasDeviceCredential = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      final types = await _auth.getAvailableBiometrics();
      return BiometricCapability(
        isSupported: hasDeviceCredential && canCheck,
        hasEnrolled: types.isNotEmpty,
        types: types,
        hasDeviceCredential: hasDeviceCredential,
      );
    } on Exception catch (error) {
      developer.log('تعذّر قراءة قدرات البصمة',
          name: 'auth.capability', level: 900, error: error);
      return const BiometricCapability(
          isSupported: false, hasEnrolled: false, types: []);
    }
  }

  /// يطلب تحققاً ويترجم أخطاء المنصة إلى [BiometricOutcome].
  ///
  /// [allowDeviceCredential] يسمح بقفل الجهاز (PIN/نمط) كبديل عن البصمة،
  /// وهو ما يجعل التحقق ممكناً على أجهزة بلا مستشعر.
  Future<BiometricResult> authenticate({
    required String reason,
    bool allowDeviceCredential = true,
  }) async {
    final capability = await this.capability();

    if (!allowDeviceCredential && !capability.isReady) {
      return BiometricResult(
        capability.isSupported
            ? BiometricOutcome.notEnrolled
            : BiometricOutcome.unavailable,
        message: capability.isSupported
            ? 'سجّل بصمتك في إعدادات الجهاز أولاً'
            : 'الجهاز لا يدعم التحقق الحيوي',
      );
    }
    if (allowDeviceCredential && !capability.hasDeviceCredential) {
      return const BiometricResult(BiometricOutcome.unavailable,
          message: 'لا يوجد قفل شاشة على هذا الجهاز');
    }

    try {
      final ok = await _auth.authenticate(
        localizedReason: reason,
        authMessages: const [_androidMessages],
        options: AuthenticationOptions(
          stickyAuth: true,
          useErrorDialogs: true,
          biometricOnly: !allowDeviceCredential,
        ),
      );
      return ok
          ? const BiometricResult(BiometricOutcome.success)
          : const BiometricResult(BiometricOutcome.failed,
              message: 'لم يكتمل التحقق');
    } on Exception catch (error, stackTrace) {
      developer.log('فشل التحقق الحيوي',
          name: 'auth.authenticate',
          level: 900,
          error: error,
          stackTrace: stackTrace);
      return _translate(error);
    }
  }

  Future<void> cancel() => _auth.stopAuthentication();

  /// أكواد المنصة تصل كنص داخل الاستثناء، فنطابقها لتصنيف السبب.
  static BiometricResult _translate(Exception error) {
    final text = error.toString();
    if (text.contains('NotEnrolled') || text.contains('PasscodeNotSet')) {
      return const BiometricResult(BiometricOutcome.notEnrolled,
          message: 'لا توجد بصمة أو قفل مسجَّل في إعدادات الجهاز');
    }
    if (text.contains('LockedOut') || text.contains('PermanentlyLockedOut')) {
      return const BiometricResult(BiometricOutcome.lockedOut,
          message: 'تم قفل التحقق مؤقتاً بعد محاولات فاشلة، جرّب لاحقاً');
    }
    if (text.contains('NotAvailable') || text.contains('OtherOperatingSystem')) {
      return const BiometricResult(BiometricOutcome.unavailable,
          message: 'التحقق الحيوي غير متاح على هذا الجهاز');
    }
    return BiometricResult(BiometricOutcome.failed, message: text);
  }

  static const _androidMessages = AndroidAuthMessages(
    signInTitle: 'تأكيد الهوية',
    cancelButton: 'إلغاء',
    biometricHint: '',
    biometricNotRecognized: 'لم يتم التعرف، حاول مرة أخرى',
    biometricRequiredTitle: 'التحقق مطلوب',
    biometricSuccess: 'تم التحقق',
    deviceCredentialsRequiredTitle: 'أدخل قفل الجهاز',
    deviceCredentialsSetupDescription: 'أعدّ قفل الجهاز للمتابعة',
    goToSettingsButton: 'فتح الإعدادات',
    goToSettingsDescription: 'سجّل بصمتك في إعدادات الجهاز لتفعيل التحقق',
  );
}
