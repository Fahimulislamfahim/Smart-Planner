import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/productivity_service.dart';
import '../tasks/task_providers.dart';

final productivityServiceProvider = Provider<ProductivityService>((ref) {
  return ProductivityService();
});

final completionRateProvider = Provider<double>((ref) {
  final service = ref.watch(productivityServiceProvider);
  final tasks = ref.watch(taskListProvider);
  return service.getCompletionRate(tasks);
});

final weeklyStatsProvider = Provider<Map<String, int>>((ref) {
  final service = ref.watch(productivityServiceProvider);
  final tasks = ref.watch(taskListProvider);
  return service.getWeeklyStats(tasks);
});
