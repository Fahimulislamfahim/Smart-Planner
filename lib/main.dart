import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/local/hive_service.dart';
import 'presentation/screens/home_screen.dart';
import 'data/repositories/app_settings_repository.dart';
import 'core/services/notification_service.dart';
import 'core/services/reminder_scheduler_service.dart';
import 'features/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await HiveService.init();
  
  // Initialize Notification Service
  final notificationService = NotificationService();
  await notificationService.init();

  // Initialize Daily Reminders
  final settingsRepository = AppSettingsRepository();
  final reminderScheduler = ReminderSchedulerService(notificationService, settingsRepository);
  await reminderScheduler.initializeDailyReminders();

  runApp(
    const ProviderScope(
      child: SmartPlannerApp(),
    ),
  );
}

class SmartPlannerApp extends ConsumerWidget {
  const SmartPlannerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Smart Planner',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      
      // Light Theme
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      
      // Dark Theme
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      
      home: const HomeScreen(),
    );
  }
}
