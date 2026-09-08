import 'package:attendance_budget_app/app.dart';
import 'package:attendance_budget_app/domain/entities/profile_entity.dart';
import 'package:attendance_budget_app/domain/entities/reminder_settings_entity.dart';
import 'package:attendance_budget_app/domain/repositories/profile_repository.dart';
import 'package:attendance_budget_app/domain/repositories/reminder_settings_repository.dart';
import 'package:attendance_budget_app/presentation/providers/profile_provider.dart';
import 'package:attendance_budget_app/presentation/providers/reminder_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// بدائل يدوية: التطبيق يقرأ من Isar، ولا قاعدة بيانات في اختبار ويدجت.
class _FakeProfileRepository implements ProfileRepository {
  @override
  Future<ProfileEntity?> getProfile() async => null;

  @override
  Future<void> updateProfile(ProfileEntity profile) async {}
}

class _FakeReminderSettingsRepository implements ReminderSettingsRepository {
  @override
  Future<ReminderSettingsEntity> get() async => const ReminderSettingsEntity();

  @override
  Future<void> save(ReminderSettingsEntity settings) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('التطبيق يقلع ويعرض الإعداد حين لا ملف شخصي', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileRepositoryProvider
              .overrideWithValue(_FakeProfileRepository()),
          reminderSettingsRepositoryProvider
              .overrideWithValue(_FakeReminderSettingsRepository()),
        ],
        child: const AttendanceBudgetApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    // البوابة تمنع الدخول قبل إنشاء الملف وأول جهة.
    expect(find.text('لنجهّز حسابك'), findsOneWidget);
  });
}
