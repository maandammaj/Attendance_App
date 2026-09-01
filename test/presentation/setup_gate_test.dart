import 'package:attendance_budget_app/core/constants/theme.dart';
import 'package:attendance_budget_app/domain/entities/profile_entity.dart';
import 'package:attendance_budget_app/domain/repositories/profile_repository.dart';
import 'package:attendance_budget_app/presentation/providers/profile_provider.dart';
import 'package:attendance_budget_app/presentation/screens/setup/setup_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// بديل يدوي عن المستودع — لا قاعدة بيانات في اختبارات الويدجت.
class _FakeProfileRepository implements ProfileRepository {
  _FakeProfileRepository(this._profile, {this.failure});

  ProfileEntity? _profile;
  final Object? failure;

  @override
  Future<ProfileEntity?> getProfile() async {
    if (failure != null) throw failure!;
    return _profile;
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) async => _profile = profile;
}

ProfileEntity _profileEntity() => ProfileEntity(
      id: 0,
      fullName: 'موظف',
      currency: 'ر.ي',
      updatedAt: DateTime(2026),
    );

Widget _harness(ProfileRepository repository) {
  return ProviderScope(
    overrides: [profileRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      locale: const Locale('ar'),
      home: const SetupGate(child: Text('التطبيق')),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('بلا ملف شخصي تُعرض شاشة الإعداد لا التطبيق', (tester) async {
    await tester.pumpWidget(_harness(_FakeProfileRepository(null)));
    await tester.pumpAndSettle();

    expect(find.text('لنجهّز حسابك'), findsOneWidget);
    expect(find.text('التطبيق'), findsNothing);
  });

  testWidgets('بوجود ملف شخصي يُعرض التطبيق مباشرة', (tester) async {
    await tester.pumpWidget(_harness(_FakeProfileRepository(_profileEntity())));
    await tester.pumpAndSettle();

    expect(find.text('التطبيق'), findsOneWidget);
    expect(find.text('لنجهّز حسابك'), findsNothing);
  });

  testWidgets('فشل القراءة يعرض خطأً قابلاً لإعادة المحاولة', (tester) async {
    await tester.pumpWidget(
      _harness(_FakeProfileRepository(null, failure: Exception('قاعدة مغلقة'))),
    );
    await tester.pumpAndSettle();

    expect(find.text('تعذّر فتح بياناتك'), findsOneWidget);
    expect(find.text('إعادة المحاولة'), findsOneWidget);
  });
}
