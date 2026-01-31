import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/assistant_service.dart';
import '../tasks/task_providers.dart';

final assistantServiceProvider = Provider<AssistantService>((ref) {
  return AssistantService();
});

final assistantMessageProvider = Provider<String>((ref) {
  final service = ref.watch(assistantServiceProvider);
  final tasks = ref.watch(todayTasksProvider); // Focus on today's tasks
  
  final greeting = service.getGreeting();
  final summary = service.getDailySummary(tasks);
  
  return "$greeting\n$summary";
});
