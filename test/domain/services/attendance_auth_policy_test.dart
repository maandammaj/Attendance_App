import 'package:attendance_budget_app/core/utils/biometric_auth.dart';
import 'package:attendance_budget_app/domain/entities/reminder_settings_entity.dart';
import 'package:attendance_budget_app/domain/services/attendance_auth_policy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';

BiometricCapability _capability({
  bool supported = false,
  bool enrolled = false,
  bool deviceCredential = false,
}) {
  return BiometricCapability(
    isSupported: supported,
    hasEnrolled: enrolled,
    hasDeviceCredential: deviceCredential,
    types: enrolled ? const [BiometricType.fingerprint] : const [],
  );
}

AuthRequirement _resolve(
  BiometricCapability capability, {
  bool require = true,
  bool allowCredential = true,
}) {
  return AttendanceAuthPolicy.resolve(
    capability: capability,
    settings: ReminderSettingsEntity(
      requireBiometricForAttendance: require,
      allowDeviceCredential: allowCredential,
    ),
  );
}

void main() {
  group('بصمة مسجّلة على الجهاز', () {
    final ready =
        _capability(supported: true, enrolled: true, deviceCredential: true);

    test('تُلزم البصمة نفسها ولا يُقبل رمز الجهاز بديلاً', () {
      expect(_resolve(ready), AuthRequirement.biometricOnly);
    });

    test('تبقى ملزمة حتى لو سُمح برمز الجهاز في الإعدادات', () {
      expect(_resolve(ready, allowCredential: true),
          AuthRequirement.biometricOnly);
    });

    test('تبقى ملزمة حتى لو أُوقف الإلزام في الإعدادات', () {
      // وجود البصمة هو ما يجعلها ملزمة؛ الإعداد يخصّ الأجهزة التي لا تملكها.
      expect(_resolve(ready, require: false), AuthRequirement.biometricOnly);
    });
  });

  group('عتاد بصمة بلا تسجيل', () {
    final unenrolled =
        _capability(supported: true, enrolled: false, deviceCredential: true);

    test('يُقبل قفل الجهاز حين يسمح الإعداد', () {
      expect(_resolve(unenrolled), AuthRequirement.deviceCredential);
    });

    test('يُمنع التسجيل حين يُمنع الرمز والإلزام قائم', () {
      expect(_resolve(unenrolled, allowCredential: false),
          AuthRequirement.blocked);
    });

    test('يمضي دون تحقق حين يُمنع الرمز والإلزام موقوف', () {
      expect(_resolve(unenrolled, allowCredential: false, require: false),
          AuthRequirement.none);
    });
  });

  group('جهاز بلا أي وسيلة تحقق', () {
    final bare = _capability();

    test('يُمنع التسجيل ما دام الإلزام قائماً', () {
      expect(_resolve(bare), AuthRequirement.blocked);
      expect(AttendanceAuthPolicy.blockedReason(bare), contains('لا يدعم'));
    });

    test('يمضي دون تحقق حين يُوقَف الإلزام', () {
      expect(_resolve(bare, require: false), AuthRequirement.none);
    });
  });

  test('رسالة المنع توجّه لتسجيل البصمة حين يدعمها الجهاز', () {
    final message = AttendanceAuthPolicy.blockedReason(
        _capability(supported: true, enrolled: false));
    expect(message, contains('لا توجد بصمة مسجّلة'));
  });
}
