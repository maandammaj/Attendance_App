import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/services/notification_service.dart';
import '../../data/local/repositories/budget_limit_repository_impl.dart';
import '../../data/local/repositories/reminder_settings_repository_impl.dart';
import '../../domain/entities/budget_limit_entity.dart';
import '../../domain/entities/reminder_settings_entity.dart';
import '../../domain/repositories/budget_limit_repository.dart';
import '../../domain/repositories/reminder_settings_repository.dart';
import '../../domain/services/reminder_scheduler.dart';
import '../../domain/services/smart_insights_service.dart';
import 'attendance_provider.dart';
import 'debt_provider.dart';
import 'company_provider.dart';
import 'transaction_provider.dart';

part 'reminder_provider.g.dart';

final reminderSettingsRepositoryProvider = Provider<ReminderSettingsRepository>(
  (ref) => ReminderSettingsRepositoryImpl(),
);

final budgetLimitRepositoryProvider = Provider<BudgetLimitRepository>(
  (ref) => BudgetLimitRepositoryImpl(),
);

final reminderSchedulerProvider = Provider(
  (ref) => ReminderScheduler(
    debtRepository: ref.read(debtRepositoryProvider),
  ),
);

final smartInsightsServiceProvider = Provider(
  (ref) => SmartInsightsService(
    transactionRepository: ref.read(transactionRepositoryProvider),
    budgetLimitRepository: ref.read(budgetLimitRepositoryProvider),
    debtRepository: ref.read(debtRepositoryProvider),
  ),
);

/// حالة تسليم التنبيهات كما يراها النظام.
@riverpod
Future<NotificationDiagnostics> notificationDiagnostics(Ref ref) async {
  return await NotificationService().diagnose();
}

@riverpod
Future<ReminderSettingsEntity> reminderSettings(Ref ref) async {
  return await ref.read(reminderSettingsRepositoryProvider).get();
}

@riverpod
Future<List<BudgetLimitEntity>> budgetLimits(Ref ref) async {
  return await ref.read(budgetLimitRepositoryProvider).getAll();
}

@riverpod
Future<List<BudgetStatusEntity>> budgetStatus(
  Ref ref, {
  required int year,
  required int month,
}) async {
  return await ref.read(budgetLimitRepositoryProvider).getStatus(year, month);
}

// keepAlive: هذه المتحكّمات بعمر التطبيق لا بعمر شاشة. بدونها يُتلَف
// المتحكّم حين تُبدَّل شاشته أثناء عملية جارية — بوابة الإعداد تفعل ذلك فور
// إنشاء أول جهة — فتُكتب الحالة على مزوّد مُتلَف ويُرمى
// "Bad state: Future already completed".
@Riverpod(keepAlive: true)
class ReminderController extends _$ReminderController {
  @override
  FutureOr<void> build() => null;

  /// يحفظ الإعدادات ثم يعيد بناء كل التنبيهات المجدولة من الحالة الجديدة.
  Future<void> saveSettings(ReminderSettingsEntity settings) async {
    state = const AsyncLoading();
    try {
      await ref.read(reminderSettingsRepositoryProvider).save(settings);
      ref.invalidate(reminderSettingsProvider);
      await _reschedule(settings);
      state = const AsyncData(null);
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }

  Future<void> saveBudgetLimit({
    required String categoryName,
    required double monthlyLimit,
  }) async {
    state = const AsyncLoading();
    try {
      await ref.read(budgetLimitRepositoryProvider).upsert(
            categoryName: categoryName,
            monthlyLimit: monthlyLimit,
          );
      _invalidateBudgets();
      state = const AsyncData(null);
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }

  Future<void> deleteBudgetLimit(int id) async {
    state = const AsyncLoading();
    try {
      await ref.read(budgetLimitRepositoryProvider).delete(id);
      _invalidateBudgets();
      state = const AsyncData(null);
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }

  Future<void> sendTest() async {
    await NotificationService().sendTestNotification();
  }

  Future<void> grantExactAlarms() async {
    await NotificationService().requestExactAlarms();
    ref.invalidate(notificationDiagnosticsProvider);
    final settings = await ref.read(reminderSettingsProvider.future);
    await _reschedule(settings);
  }

  /// يُستدعى عند إقلاع الواجهة: يطلب الأذونات، يعيد الجدولة، ثم يقيّم الرؤى.
  Future<void> runStartupCycle() async {
    final granted = await NotificationService().requestPermissions();
    if (!granted) return;

    final settings = await ref.read(reminderSettingsProvider.future);
    await _reschedule(settings);

    await ref.read(smartInsightsServiceProvider).run(
          company: await ref.read(activeCompanyProvider.future),
          settings: settings,
          todayRecord: await ref.read(todayAttendanceProvider.future),
        );
  }

  Future<void> _reschedule(ReminderSettingsEntity settings) async {
    await ref.read(reminderSchedulerProvider).rescheduleAll(
          company: await ref.read(activeCompanyProvider.future),
          settings: settings,
        );
  }

  void _invalidateBudgets() {
    ref.invalidate(budgetLimitsProvider);
    ref.invalidate(budgetStatusProvider);
  }
}
