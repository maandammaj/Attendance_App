import 'package:isar_community/isar.dart';

import '../../../domain/entities/reminder_settings_entity.dart';
import '../../../domain/repositories/reminder_settings_repository.dart';
import '../../models/reminder_settings_model.dart';
import '../database/isar_database.dart';

class ReminderSettingsRepositoryImpl implements ReminderSettingsRepository {
  Future<Isar> get _db async => await IsarDatabase.instance;

  @override
  Future<ReminderSettingsEntity> get() async {
    final isar = await _db;
    final model = await isar.reminderSettingsModels.get(0);
    // أول تشغيل: القيم الافتراضية للكيان هي نفسها الافتراضيات في النموذج.
    return model == null ? const ReminderSettingsEntity() : _mapToEntity(model);
  }

  @override
  Future<void> save(ReminderSettingsEntity settings) async {
    final isar = await _db;
    await isar.writeTxn(() async {
      await isar.reminderSettingsModels.put(_mapToModel(settings));
    });
  }

  ReminderSettingsEntity _mapToEntity(ReminderSettingsModel m) {
    return ReminderSettingsEntity(
      shiftStartEnabled: m.shiftStartEnabled,
      shiftStartLeadMinutes: m.shiftStartLeadMinutes,
      shiftEndEnabled: m.shiftEndEnabled,
      shiftEndLeadMinutes: m.shiftEndLeadMinutes,
      requiredHoursDoneEnabled: m.requiredHoursDoneEnabled,
      forgotCheckOutEnabled: m.forgotCheckOutEnabled,
      forgotCheckOutAfterHours: m.forgotCheckOutAfterHours,
      missedCheckInEnabled: m.missedCheckInEnabled,
      missedCheckInAfterMinutes: m.missedCheckInAfterMinutes,
      debtDueEnabled: m.debtDueEnabled,
      debtDueLeadDays: m.debtDueLeadDays,
      debtOverdueEnabled: m.debtOverdueEnabled,
      budgetOverrunEnabled: m.budgetOverrunEnabled,
      budgetWarnThreshold: m.budgetWarnThreshold,
      unusualSpendingEnabled: m.unusualSpendingEnabled,
      debtRatioEnabled: m.debtRatioEnabled,
      debtRatioThreshold: m.debtRatioThreshold,
      monthEndForecastEnabled: m.monthEndForecastEnabled,
      dailySummaryEnabled: m.dailySummaryEnabled,
      dailySummaryTime: m.dailySummaryTime,
      weeklySummaryEnabled: m.weeklySummaryEnabled,
      weeklySummaryDayOfWeek: m.weeklySummaryDayOfWeek,
      weeklySummaryTime: m.weeklySummaryTime,
      monthlySummaryEnabled: m.monthlySummaryEnabled,
      monthlySummaryDayOfMonth: m.monthlySummaryDayOfMonth,
      monthlySummaryTime: m.monthlySummaryTime,
      recurringExpenseEnabled: m.recurringExpenseEnabled,
      quietHoursEnabled: m.quietHoursEnabled,
      quietHoursStart: m.quietHoursStart,
      quietHoursEnd: m.quietHoursEnd,
      requireBiometricForAttendance: m.requireBiometricForAttendance,
      appLockEnabled: m.appLockEnabled,
      allowDeviceCredential: m.allowDeviceCredential,
    );
  }

  ReminderSettingsModel _mapToModel(ReminderSettingsEntity e) {
    return ReminderSettingsModel()
      ..id = 0
      ..shiftStartEnabled = e.shiftStartEnabled
      ..shiftStartLeadMinutes = e.shiftStartLeadMinutes
      ..shiftEndEnabled = e.shiftEndEnabled
      ..shiftEndLeadMinutes = e.shiftEndLeadMinutes
      ..requiredHoursDoneEnabled = e.requiredHoursDoneEnabled
      ..forgotCheckOutEnabled = e.forgotCheckOutEnabled
      ..forgotCheckOutAfterHours = e.forgotCheckOutAfterHours
      ..missedCheckInEnabled = e.missedCheckInEnabled
      ..missedCheckInAfterMinutes = e.missedCheckInAfterMinutes
      ..debtDueEnabled = e.debtDueEnabled
      ..debtDueLeadDays = e.debtDueLeadDays
      ..debtOverdueEnabled = e.debtOverdueEnabled
      ..budgetOverrunEnabled = e.budgetOverrunEnabled
      ..budgetWarnThreshold = e.budgetWarnThreshold
      ..unusualSpendingEnabled = e.unusualSpendingEnabled
      ..debtRatioEnabled = e.debtRatioEnabled
      ..debtRatioThreshold = e.debtRatioThreshold
      ..monthEndForecastEnabled = e.monthEndForecastEnabled
      ..dailySummaryEnabled = e.dailySummaryEnabled
      ..dailySummaryTime = e.dailySummaryTime
      ..weeklySummaryEnabled = e.weeklySummaryEnabled
      ..weeklySummaryDayOfWeek = e.weeklySummaryDayOfWeek
      ..weeklySummaryTime = e.weeklySummaryTime
      ..monthlySummaryEnabled = e.monthlySummaryEnabled
      ..monthlySummaryDayOfMonth = e.monthlySummaryDayOfMonth
      ..monthlySummaryTime = e.monthlySummaryTime
      ..recurringExpenseEnabled = e.recurringExpenseEnabled
      ..quietHoursEnabled = e.quietHoursEnabled
      ..quietHoursStart = e.quietHoursStart
      ..quietHoursEnd = e.quietHoursEnd
      ..requireBiometricForAttendance = e.requireBiometricForAttendance
      ..appLockEnabled = e.appLockEnabled
      ..allowDeviceCredential = e.allowDeviceCredential
      ..updatedAt = DateTime.now();
  }
}
