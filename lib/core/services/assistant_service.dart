import '../../data/models/task_model.dart';

import 'dart:math';
import '../constants/assistant_messages.dart';

class AssistantService {
  String getGreeting() {
    final hour = DateTime.now().hour;
    final random = Random();

    if (hour >= 5 && hour < 8) {
      return AssistantMessages.earlyMorningMessages[
          random.nextInt(AssistantMessages.earlyMorningMessages.length)];
    } else if (hour >= 8 && hour < 12) {
      return AssistantMessages.lateMorningMessages[
          random.nextInt(AssistantMessages.lateMorningMessages.length)];
    } else if (hour >= 12 && hour < 17) {
      return AssistantMessages.afternoonMessages[
          random.nextInt(AssistantMessages.afternoonMessages.length)];
    } else if (hour >= 17 && hour < 21) {
      return AssistantMessages.eveningMessages[
          random.nextInt(AssistantMessages.eveningMessages.length)];
    } else {
      // Late Night (21:00 - 4:59)
      return AssistantMessages.lateNightMessages[
          random.nextInt(AssistantMessages.lateNightMessages.length)];
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
