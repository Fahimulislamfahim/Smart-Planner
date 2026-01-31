import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

part 'app_theme.g.dart';

@HiveType(typeId: 4)
class AppTheme extends HiveObject {
  @HiveField(0)
  String themeName;

  @HiveField(1)
  int primaryColorValue;

  @HiveField(2)
  bool isDark;

  AppTheme({
    required this.themeName,
    required this.primaryColorValue,
    required this.isDark,
  });

  Color get primaryColor => Color(primaryColorValue);

  set primaryColor(Color value) {
    primaryColorValue = value.value;
  }

  ThemeData toThemeData() {
    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );
  }

  static List<AppTheme> getPresetThemes() {
    return [
      AppTheme(themeName: 'Light Blue', primaryColorValue: Colors.blue.value, isDark: false),
      AppTheme(themeName: 'Dark Blue', primaryColorValue: Colors.blue.value, isDark: true),
      AppTheme(themeName: 'Light Green', primaryColorValue: Colors.green.value, isDark: false),
      AppTheme(themeName: 'Dark Green', primaryColorValue: Colors.green.value, isDark: true),
      AppTheme(themeName: 'Light Purple', primaryColorValue: Colors.purple.value, isDark: false),
      AppTheme(themeName: 'Dark Purple', primaryColorValue: Colors.purple.value, isDark: true),
      AppTheme(themeName: 'AMOLED Black', primaryColorValue: Colors.blue.value, isDark: true),
    ];
  }
}

// Theme provider
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(ThemeData.light(useMaterial3: true));

  void setTheme(AppTheme theme) {
    state = theme.toThemeData();
  }
}
