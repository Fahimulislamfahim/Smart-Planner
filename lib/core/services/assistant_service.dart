import '../../data/models/task_model.dart';

class AssistantService {
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  String getDailySummary(List<Task> tasks) {
    if (tasks.isEmpty) {
      return "You're all caught up! Enjoy your day.";
    }

    final pendingTasks = tasks.where((t) => !t.isCompleted).toList();
    final highPriority = pendingTasks.where((t) => t.priority == 'High').length;

    if (pendingTasks.isEmpty) {
      return "Great job! All tasks completed.";
    }

    if (highPriority > 0) {
      return "You have $highPriority high priority tasks remaining. Let's focus inside!";
    }

    return "You have ${pendingTasks.length} tasks on your list. Keep it up!";
  }
}
