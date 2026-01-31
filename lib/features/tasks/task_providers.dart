import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/task_model.dart';
import '../../data/models/app_settings.dart';
import '../../data/repositories/task_repository.dart';
import '../../core/services/notification_service.dart';
import '../settings/settings_providers.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});

final taskListProvider = StateNotifierProvider<TaskListNotifier, List<Task>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  final notificationService = ref.watch(notificationServiceProvider);
  final settings = ref.watch(appSettingsProvider);
  return TaskListNotifier(repository, notificationService, settings);
});

class TaskListNotifier extends StateNotifier<List<Task>> {
  final TaskRepository _repository;
  final NotificationService _notificationService;
  final AppSettings _settings;

  TaskListNotifier(this._repository, this._notificationService, this._settings) : super([]) {
    loadTasks();
  }

  void loadTasks() {
    state = _repository.getTasks();
  }

  Future<void> addTask(Task task) async {
    await _repository.addTask(task);
    
    // Schedule notification if reminder is enabled and task has a time
    if (task.hasReminder && task.time != null) {
      await _scheduleTaskNotification(task);
    }
    
    loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await _repository.updateTask(task);
    
    // Cancel old notification
    final notificationId = task.key as int? ?? task.id.hashCode;
    await _notificationService.cancelNotification(notificationId);
    
    // Reschedule if reminder is still enabled and not completed
    if (task.hasReminder && !task.isCompleted && task.time != null) {
      await _scheduleTaskNotification(task);
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
      // Cancel notification when task is completed
      await _notificationService.cancelNotification(notificationId);
    } else if (updatedTask.hasReminder && updatedTask.time != null) {
      // Reschedule if uncompleted and still in future
      await _scheduleTaskNotification(updatedTask);
    }
    
    loadTasks();
  }

  Future<void> _scheduleTaskNotification(Task task) async {
    try {
      final timeParts = task.time!.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final taskTime = DateTime(
        task.date.year,
        task.date.month,
        task.date.day,
        hour,
        minute,
      );

      // Use task-specific offset or default from settings
      final offsetMinutes = task.reminderOffsetMinutes ?? _settings.defaultTaskReminderOffset;

      // Only schedule if task time is in the future
      if (taskTime.isAfter(DateTime.now())) {
        final notificationId = task.key as int? ?? task.id.hashCode;
        await _notificationService.scheduleTaskReminder(
          id: notificationId,
          title: '⏰ Reminder: ${task.title}',
          body: task.description ?? 'Your task is coming up in $offsetMinutes minutes!',
          taskTime: taskTime,
          minutesBefore: offsetMinutes,
        );
      }
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
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
