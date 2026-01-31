import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/app_settings_repository.dart';
import '../../data/models/app_settings.dart';
import '../../core/services/reminder_scheduler_service.dart';
import '../../core/services/notification_service.dart';

final settingsRepositoryProvider = Provider<AppSettingsRepository>((ref) {
  return AppSettingsRepository();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final reminderSchedulerProvider = Provider<ReminderSchedulerService>((ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  return ReminderSchedulerService(notificationService, settingsRepository);
});

final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  final reminderScheduler = ref.watch(reminderSchedulerProvider);
  return AppSettingsNotifier(repository, reminderScheduler);
});

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  final AppSettingsRepository _repository;
  final ReminderSchedulerService _reminderScheduler;

  AppSettingsNotifier(this._repository, this._reminderScheduler) : super(AppSettings.defaultSettings()) {
    _loadSettings();
  }

  void _loadSettings() {
    state = _repository.getSettings();
  }

  Future<void> updateSettings(AppSettings settings) async {
    await _repository.updateSettings(settings);
    state = settings;
    
    // Update daily reminders when settings change
    await _reminderScheduler.updateMorningReminder(
      settings.morningReminderTime,
      settings.enableMorningReminder,
    );
    await _reminderScheduler.updateEveningReminder(
      settings.eveningReminderTime,
      settings.enableEveningReminder,
    );
  }

  Future<void> toggleMorningReminder(bool enabled) async {
    final updatedSettings = state.copyWith(enableMorningReminder: enabled);
    await updateSettings(updatedSettings);
  }

  Future<void> setMorningReminderTime(String time) async {
    final updatedSettings = state.copyWith(morningReminderTime: time);
    await updateSettings(updatedSettings);
  }

  Future<void> toggleEveningReminder(bool enabled) async {
    final updatedSettings = state.copyWith(enableEveningReminder: enabled);
    await updateSettings(updatedSettings);
  }

  Future<void> setEveningReminderTime(String time) async {
    final updatedSettings = state.copyWith(eveningReminderTime: time);
    await updateSettings(updatedSettings);
  }

  Future<void> setDefaultTaskReminderOffset(int minutes) async {
    final updatedSettings = state.copyWith(defaultTaskReminderOffset: minutes);
    await updateSettings(updatedSettings);
  }
}
