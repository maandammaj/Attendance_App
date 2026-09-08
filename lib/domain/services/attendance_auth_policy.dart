import '../../core/utils/biometric_auth.dart';
import '../entities/reminder_settings_entity.dart';

/// ما يجب فعله قبل تسجيل حضور أو انصراف.
enum AuthRequirement {
  /// الجهاز يملك بصمة مسجّلة: التحقق بها إلزامي، ولا يُقبل قفل الجهاز بديلاً.
  biometricOnly,

  /// لا بصمة مسجّلة لكن قفل الجهاز متاح ومسموح به في الإعدادات.
  deviceCredential,

  /// لا وسيلة تحقق على الجهاز والإعدادات لا تُلزم بها.
  none,

  /// لا وسيلة تحقق والإعدادات تُلزم بها — تُمنع العملية.
  blocked,
}

/// يقرر مستوى التحقق المطلوب من قدرات الجهاز والإعدادات.
///
/// مفصولة عن الـcontroller لأنها القاعدة الأمنية الفعلية: متى تُقبل بصمة،
/// ومتى يُقبل رمز، ومتى يُمنع التسجيل. دالة نقية حتى تُختبر بلا جهاز.
class AttendanceAuthPolicy {
  const AttendanceAuthPolicy._();

  static AuthRequirement resolve({
    required BiometricCapability capability,
    required ReminderSettingsEntity settings,
  }) {
    // بصمة مسجّلة فعلاً ⇒ تُستخدم البصمة نفسها، لا بديل عنها. السماح برمز
    // الجهاز هنا يفرّغ التحقق من معناه: أي شخص يعرف الرمز يسجّل دوام غيره.
    if (capability.isReady) return AuthRequirement.biometricOnly;

    if (settings.allowDeviceCredential && capability.hasDeviceCredential) {
      return AuthRequirement.deviceCredential;
    }

    return settings.requireBiometricForAttendance
        ? AuthRequirement.blocked
        : AuthRequirement.none;
  }

  /// رسالة تشرح سبب المنع وتقترح المخرج.
  static String blockedReason(BiometricCapability capability) {
    if (!capability.isSupported) {
      return 'هذا الجهاز لا يدعم التحقق الحيوي. أوقف إلزام البصمة من إعدادات '
          'التذكيرات لتسجيل الدوام بدونها.';
    }
    return 'لا توجد بصمة مسجّلة على الجهاز. سجّلها من إعدادات الجهاز، أو أوقف '
        'إلزام البصمة من إعدادات التذكيرات.';
  }
}
