import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../features/settings/settings_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final List<int> _reminderOffsetOptions = [5, 10, 15, 30, 60];

  Future<void> _pickTime(BuildContext context, String currentTime, Function(String) onTimePicked) async {
    final timeParts = currentTime.split(':');
    final initialTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      final formattedTime = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      onTimePicked(formattedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsProvider);
    final settingsNotifier = ref.read(appSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Daily Reminders Section
          Text(
            'Daily Reminders',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Morning Reminder
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Morning Reminder'),
                  subtitle: const Text('Get reminded to check your tasks'),
                  value: settings.enableMorningReminder,
                  onChanged: (value) {
                    settingsNotifier.toggleMorningReminder(value);
                  },
                  secondary: const Icon(Icons.wb_sunny),
                ),
                if (settings.enableMorningReminder)
                  ListTile(
                    title: const Text('Morning Time'),
                    subtitle: Text(
                      DateFormat.jm().format(
                        DateTime(2000, 1, 1, 
                          int.parse(settings.morningReminderTime.split(':')[0]),
                          int.parse(settings.morningReminderTime.split(':')[1]),
                        ),
                      ),
                    ),
                    trailing: const Icon(Icons.access_time),
                    onTap: () {
                      _pickTime(context, settings.morningReminderTime, (time) {
                        settingsNotifier.setMorningReminderTime(time);
                      });
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Evening Reminder
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Evening Reminder'),
                  subtitle: const Text('Review your day and plan ahead'),
                  value: settings.enableEveningReminder,
                  onChanged: (value) {
                    settingsNotifier.toggleEveningReminder(value);
                  },
                  secondary: const Icon(Icons.nightlight_round),
                ),
                if (settings.enableEveningReminder)
                  ListTile(
                    title: const Text('Evening Time'),
                    subtitle: Text(
                      DateFormat.jm().format(
                        DateTime(2000, 1, 1, 
                          int.parse(settings.eveningReminderTime.split(':')[0]),
                          int.parse(settings.eveningReminderTime.split(':')[1]),
                        ),
                      ),
                    ),
                    trailing: const Icon(Icons.access_time),
                    onTap: () {
                      _pickTime(context, settings.eveningReminderTime, (time) {
                        settingsNotifier.setEveningReminderTime(time);
                      });
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Task Reminders Section
          Text(
            'Task Reminders',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Card(
            child: ListTile(
              title: const Text('Default Reminder Time'),
              subtitle: Text('Notify ${settings.defaultTaskReminderOffset} minutes before task'),
              trailing: DropdownButton<int>(
                value: settings.defaultTaskReminderOffset,
                items: _reminderOffsetOptions.map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value min'),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    settingsNotifier.setDefaultTaskReminderOffset(newValue);
                  }
                },
              ),
              leading: const Icon(Icons.notifications_active),
            ),
          ),
          const SizedBox(height: 32),

          // Info Card
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'About Notifications',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Daily reminders help you stay on track. Task reminders notify you before each scheduled task. Make sure notifications are enabled in your device settings.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
