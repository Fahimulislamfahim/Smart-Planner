import '../../data/models/task_model.dart';

class ProductivityService {
  /// Returns the completion rate as a percentage (0.0 to 1.0)
  double getCompletionRate(List<Task> tasks) {
    if (tasks.isEmpty) return 0.0;
    final completedCount = tasks.where((t) => t.isCompleted).length;
    return completedCount / tasks.length;
  }

  /// Returns a map of <DayName, CompletedCount> for the last 7 days
  /// e.g. {'Mon': 2, 'Tue': 5, ...}
  Map<String, int> getWeeklyStats(List<Task> tasks) {
    final now = DateTime.now();
    final Map<String, int> stats = {};

    // Generate last 7 days keys
    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final dayName = _getDayName(day.weekday);
      stats[dayName] = 0;
    }

    // Fill with data
    for (var task in tasks) {
      if (task.isCompleted) {
         // Assuming we track completion date. The current Task model only has 'date' (due date).
         // For this MVP, we will count tasks *due* on that day that are completed.
         // Ideally, we should add a 'completedAt' field to the Task model.
         
         final taskDate = task.date;
         if (taskDate.isAfter(now.subtract(const Duration(days: 7))) && 
             taskDate.isBefore(now.add(const Duration(days: 1)))) {
            final dayName = _getDayName(taskDate.weekday);
            if (stats.containsKey(dayName)) {
              stats[dayName] = (stats[dayName] ?? 0) + 1;
            }
         }
      }
    }
    return stats;
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }
}
