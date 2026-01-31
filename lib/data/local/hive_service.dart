import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';
import '../models/app_settings.dart';
import '../models/category.dart';
import '../models/subtask.dart';
import '../models/app_theme.dart';

class HiveService {
  static const String taskBoxName = 'tasks';
  static const String settingsBoxName = 'settings';
  static const String categoryBoxName = 'categories';

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register Adapters
    Hive.registerAdapter(TaskAdapter()); 
    Hive.registerAdapter(AppSettingsAdapter());
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(SubtaskAdapter());
    Hive.registerAdapter(AppThemeAdapter());
    
    // Open Boxes
    await Hive.openBox<Task>(taskBoxName);
    await Hive.openBox(settingsBoxName);
    await Hive.openBox<Category>(categoryBoxName);
    await Hive.openBox<Subtask>('subtasks');

  }

  static Box<Task> getTaskBox() {
    return Hive.box<Task>(taskBoxName);
  }

  static Box getSettingsBox() {
    return Hive.box(settingsBoxName);
  }

  static Box<Category> getCategoryBox() {
    return Hive.box<Category>(categoryBoxName);
  }
}
