import '../entities/reminder_settings_entity.dart';

abstract class ReminderSettingsRepository {
  Future<ReminderSettingsEntity> get();
  Future<void> save(ReminderSettingsEntity settings);
}
