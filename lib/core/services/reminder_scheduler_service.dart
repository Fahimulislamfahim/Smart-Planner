import 'package:flutter/foundation.dart';
import '../../data/repositories/app_settings_repository.dart';
import 'notification_service.dart';

class ReminderSchedulerService {
  final NotificationService _notificationService;
  final AppSettingsRepository _settingsRepository;

  ReminderSchedulerService(this._notificationService, this._settingsRepository);

  /// Initialize daily reminders based on current settings
  Future<void> initializeDailyReminders() async {
    final settings = _settingsRepository.getSettings();
    
    if (settings.enableMorningReminder) {
      await _scheduleMorningReminder(settings.morningReminderTime);
    } else {
      await _notificationService.cancelNotification(NotificationService.morningReminderId);
    }

    if (settings.enableEveningReminder) {
      await _scheduleEveningReminder(settings.eveningReminderTime);
    } else {
      await _notificationService.cancelNotification(NotificationService.eveningReminderId);
    }
  }

  Future<void> _scheduleMorningReminder(String time) async {
    try {
      await _notificationService.scheduleDailyReminder(
        id: NotificationService.morningReminderId,
        title: '🌅 Good Morning!',
        body: 'Check your tasks for today and plan your day ahead.',
        time: time,
      );
      if (kDebugMode) {
        print('Morning reminder scheduled for $time');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error scheduling morning reminder: $e');
      }
    }
  }

  Future<void> _scheduleEveningReminder(String time) async {
    try {
      await _notificationService.scheduleDailyReminder(
        id: NotificationService.eveningReminderId,
        title: '🌙 Good Evening!',
        body: 'Review your day and prepare for tomorrow\'s tasks.',
        time: time,
      );
      if (kDebugMode) {
        print('Evening reminder scheduled for $time');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error scheduling evening reminder: $e');
      }
    }
  }

  /// Update morning reminder time
  Future<void> updateMorningReminder(String time, bool enabled) async {
    if (enabled) {
      await _scheduleMorningReminder(time);
    } else {
      await _notificationService.cancelNotification(NotificationService.morningReminderId);
    }
  }

  /// Update evening reminder time
  Future<void> updateEveningReminder(String time, bool enabled) async {
    if (enabled) {
      await _scheduleEveningReminder(time);
    } else {
      await _notificationService.cancelNotification(NotificationService.eveningReminderId);
    }
  }
}
