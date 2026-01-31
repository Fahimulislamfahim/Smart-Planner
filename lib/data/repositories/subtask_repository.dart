import 'package:hive_flutter/hive_flutter.dart';
import '../local/hive_service.dart';
import '../models/subtask.dart';

class SubtaskRepository {
  static const String subtaskBoxName = 'subtasks';
  Box<Subtask> get _box => Hive.box<Subtask>(subtaskBoxName);

  static Future<void> openBox() async {
    await Hive.openBox<Subtask>(subtaskBoxName);
  }

  List<Subtask> getSubtasks(List<String> subtaskIds) {
    return subtaskIds
        .map((id) => _box.get(id))
        .where((subtask) => subtask != null)
        .cast<Subtask>()
        .toList();
  }

  Future<void> addSubtask(Subtask subtask) async {
    await _box.put(subtask.id, subtask);
  }

  Future<void> updateSubtask(Subtask subtask) async {
    await _box.put(subtask.id, subtask);
  }

  Future<void> deleteSubtask(String id) async {
    await _box.delete(id);
  }

  Subtask? getSubtaskById(String id) {
    return _box.get(id);
  }
}
