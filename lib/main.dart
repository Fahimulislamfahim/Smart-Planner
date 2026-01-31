import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/themes/app_theme.dart';
import 'core/services/notification_service.dart';
import 'data/local/hive_service.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await HiveService.init();
  
  // Initialize Notification Service
  await NotificationService().init();

  runApp(
    const ProviderScope(
      child: SmartPlannerApp(),
    ),
  );
}

class SmartPlannerApp extends StatelessWidget {
  const SmartPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Planner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme, // Optional: Implement dark theme
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
