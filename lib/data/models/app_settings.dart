import 'package:hive/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 1)
class AppSettings extends HiveObject {
  @HiveField(0)
  bool enableMorningReminder;

  @HiveField(1)
  String morningReminderTime; // Format: "HH:mm"

  @HiveField(2)
  bool enableEveningReminder;

  @HiveField(3)
  String eveningReminderTime; // Format: "HH:mm"

  @HiveField(4)
  int defaultTaskReminderOffset; // Minutes before task time

  AppSettings({
    this.enableMorningReminder = true,
    this.morningReminderTime = '08:00',
    this.enableEveningReminder = true,
    this.eveningReminderTime = '20:00',
    this.defaultTaskReminderOffset = 15,
  });

  factory AppSettings.defaultSettings() {
    return AppSettings();
  }

  AppSettings copyWith({
    bool? enableMorningReminder,
    String? morningReminderTime,
    bool? enableEveningReminder,
    String? eveningReminderTime,
    int? defaultTaskReminderOffset,
  }) {
    return AppSettings(
      enableMorningReminder: enableMorningReminder ?? this.enableMorningReminder,
      morningReminderTime: morningReminderTime ?? this.morningReminderTime,
      enableEveningReminder: enableEveningReminder ?? this.enableEveningReminder,
      eveningReminderTime: eveningReminderTime ?? this.eveningReminderTime,
      defaultTaskReminderOffset: defaultTaskReminderOffset ?? this.defaultTaskReminderOffset,
    );
  }
}
