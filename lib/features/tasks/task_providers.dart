import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository.dart';
import '../../core/services/notification_service.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});

final taskListProvider = StateNotifierProvider<TaskListNotifier, List<Task>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TaskListNotifier(repository);
});

class TaskListNotifier extends StateNotifier<List<Task>> {
  final TaskRepository _repository;
  final NotificationService _notificationService = NotificationService();

  TaskListNotifier(this._repository) : super([]) {
    loadTasks();
  }

  void loadTasks() {
    state = _repository.getTasks();
  }

  Future<void> addTask(Task task) async {
    await _repository.addTask(task);
    if (task.hasReminder && task.time != null) {
      try {
        final timeParts = task.time!.split(':');
        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);
        final scheduleTime = DateTime(
          task.date.year,
          task.date.month,
          task.date.day,
          hour,
          minute,
        );

        // Only schedule if it's in the future
        if (scheduleTime.isAfter(DateTime.now())) {
          await _notificationService.scheduleNotification(
            id: task.key as int? ?? task.id.hashCode,
            title: 'Reminder: ${task.title}',
            body: task.description ?? 'It\'s time for your task!',
            scheduledDate: scheduleTime,
          );
        }
      } catch (e) {
        debugPrint('Error scheduling notification: $e');
      }
    }
    loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await _repository.updateTask(task);
    // Re-schedule logic would go here (cancel old, schedule new)
    // Minimally:
    final notificationId = task.key as int? ?? task.id.hashCode;
    if (task.hasReminder && !task.isCompleted && task.time != null) {
       // Similar parsing logic as addTask...
       // For MVP, simplistic re-schedule
    } else {
       await _notificationService.cancelNotification(notificationId);
    }
    loadTasks();
  }

  Future<void> deleteTask(Task task) async {
    await _repository.deleteTask(task.id);
    final notificationId = task.key as int? ?? task.id.hashCode;
    await _notificationService.cancelNotification(notificationId);
    loadTasks();
  }

  Future<void> toggleTaskCompletion(Task task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await _repository.updateTask(updatedTask);
    
    final notificationId = task.key as int? ?? task.id.hashCode;
    if (updatedTask.isCompleted) {
      await _notificationService.cancelNotification(notificationId);
    } 
    // Ideally re-schedule if un-completed and still in future, but simple for now.
    
    loadTasks();
  }
}

// Derived Providers
final todayTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(taskListProvider);
  final now = DateTime.now();
  return tasks.where((task) {
    if (task.isCompleted) return false;
    return isSameDay(task.date, now);
  }).toList();
});

final tomorrowTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(taskListProvider);
  final now = DateTime.now();
  final tomorrow = now.add(const Duration(days: 1));
  return tasks.where((task) {
    if (task.isCompleted) return false;
    return isSameDay(task.date, tomorrow);
  }).toList();
});

final upcomingTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(taskListProvider);
  final now = DateTime.now();
  final tomorrow = now.add(const Duration(days: 1));
  return tasks.where((task) {
    if (task.isCompleted) return false;
    final taskDate = DateUtils.dateOnly(task.date);
    final tomorrowDate = DateUtils.dateOnly(tomorrow);
    return taskDate.isAfter(tomorrowDate);
  }).toList();
});

final completedTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(taskListProvider);
  return tasks.where((task) => task.isCompleted).toList();
});

bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
