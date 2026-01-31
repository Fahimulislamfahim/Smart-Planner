import 'package:hive_flutter/hive_flutter.dart';
import '../local/hive_service.dart';
import '../models/app_settings.dart';

class AppSettingsRepository {
  static const String _settingsKey = 'app_settings';
  
  Box get _box => HiveService.getSettingsBox();

  AppSettings getSettings() {
    final settings = _box.get(_settingsKey);
    if (settings == null) {
      // Return default settings if none exist
      final defaultSettings = AppSettings.defaultSettings();
      _box.put(_settingsKey, defaultSettings);
      return defaultSettings;
    }
    return settings as AppSettings;
  }

  Future<void> updateSettings(AppSettings settings) async {
    await _box.put(_settingsKey, settings);
  }

  Stream<BoxEvent> watchSettings() {
    return _box.watch(key: _settingsKey);
  }
}
