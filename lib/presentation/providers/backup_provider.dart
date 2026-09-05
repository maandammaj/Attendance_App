import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/backup/backup_service.dart';
import '../../core/services/backup/drive_sync_service.dart';
import 'account_provider.dart';
import 'analytics_provider.dart';
import 'attendance_provider.dart';
import 'company_provider.dart';
import 'dashboard_provider.dart';
import 'debt_provider.dart';
import 'profile_provider.dart';
import 'reminder_provider.dart';
import 'transaction_provider.dart';

final backupServiceProvider = Provider((ref) => const BackupService());
final driveSyncServiceProvider = Provider((ref) => DriveSyncService());

/// حالة الاتصال بحساب Drive.
///
/// مكتوب بمزوّدات صريحة لا بتوليد الشيفرة: `build_runner` لا يعمل على
/// Dart 3.13 (المحلّل الذي يفرضه `isar_community_generator` لا يقرأ نحوها)،
/// فملف `.g.dart` لهذا المزوّد لا يمكن توليده اليوم.
final driveStatusProvider = FutureProvider<DriveStatus>((ref) async {
  return await ref.read(driveSyncServiceProvider).status();
});

final backupControllerProvider =
    AsyncNotifierProvider<BackupController, void>(BackupController.new);

class BackupController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() => null;

  Future<String?> signIn() async {
    state = const AsyncLoading();
    try {
      final email = await ref.read(driveSyncServiceProvider).signIn();
      ref.invalidate(driveStatusProvider);
      state = const AsyncData(null);
      return email;
    } catch (error, stack) {
      state = AsyncError(error, stack);
      return null;
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      await ref.read(driveSyncServiceProvider).signOut();
      ref.invalidate(driveStatusProvider);
      state = const AsyncData(null);
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }

  Future<DateTime?> upload() async {
    state = const AsyncLoading();
    try {
      final at = await ref.read(driveSyncServiceProvider).upload();
      ref.invalidate(driveStatusProvider);
      state = const AsyncData(null);
      return at;
    } catch (error, stack) {
      state = AsyncError(error, stack);
      return null;
    }
  }

  /// يستعيد النسخة ثم يُبطل كل شيء: المحتوى تبدّل بالكامل تحت المزوّدات.
  Future<int?> restore() async {
    state = const AsyncLoading();
    try {
      final rows = await ref.read(driveSyncServiceProvider).restore();
      _invalidateEverything();
      state = const AsyncData(null);
      return rows;
    } catch (error, stack) {
      state = AsyncError(error, stack);
      return null;
    }
  }

  void _invalidateEverything() {
    ref.invalidate(profileProvider);
    ref.invalidate(companiesProvider);
    ref.invalidate(activeCompanyProvider);
    ref.invalidate(todayAttendanceProvider);
    ref.invalidate(anyOpenSessionProvider);
    ref.invalidate(monthlyAttendanceProvider);
    ref.invalidate(attendanceStatsProvider);
    ref.invalidate(dashboardDataProvider);
    ref.invalidate(monthlyTransactionsProvider);
    ref.invalidate(allDebtsProvider);
    ref.invalidate(debtSummaryProvider);
    ref.invalidate(allAccountsProvider);
    ref.invalidate(budgetLimitsProvider);
    ref.invalidate(budgetStatusProvider);
    ref.invalidate(reminderSettingsProvider);
    ref.invalidate(analyticsReportProvider);
    ref.invalidate(driveStatusProvider);
  }
}
