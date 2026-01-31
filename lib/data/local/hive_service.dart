import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';

class HiveService {
  static const String taskBoxName = 'tasks';
  static const String settingsBoxName = 'settings';

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register Adapters
    Hive.registerAdapter(TaskAdapter()); 
    
    // Open Boxes
    await Hive.openBox<Task>(taskBoxName);
    await Hive.openBox(settingsBoxName);

  }

  static Box<Task> getTaskBox() {
    return Hive.box<Task>(taskBoxName);
  }

  static Box getSettingsBox() {
    return Hive.box(settingsBoxName);
  }
}
