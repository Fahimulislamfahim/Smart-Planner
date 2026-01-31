import 'package:hive_flutter/hive_flutter.dart';
import '../local/hive_service.dart';
import '../models/task_model.dart';

class TaskRepository {
  Box<Task> get _box => HiveService.getTaskBox();

  List<Task> getTasks() {
    return _box.values.toList();
  }

  Future<void> addTask(Task task) async {
    await _box.put(task.id, task);
  }

  Future<void> updateTask(Task task) async {
    await _box.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    await _box.delete(id);
  }

  Stream<BoxEvent> watchTasks() {
    return _box.watch();
  }
}
