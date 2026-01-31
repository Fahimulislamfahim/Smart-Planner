import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/task_model.dart';
import '../../features/tasks/task_providers.dart';

class TestDataScreen extends ConsumerWidget {
  const TestDataScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Data Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Generate Test Data',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                _createTaskWithSubtasks(ref);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Created task with 3 subtasks!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.checklist),
              label: const Text('Create Task with Subtasks'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'How to Test Subtasks',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text('1. Tap "Create Task with Subtasks" above'),
                    SizedBox(height: 4),
                    Text('2. Go back to Tasks tab'),
                    SizedBox(height: 4),
                    Text('3. Find the "Project Planning" task'),
                    SizedBox(height: 4),
                    Text('4. Tap on it to open details'),
                    SizedBox(height: 4),
                    Text('5. Scroll down to see the Subtasks section'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createTaskWithSubtasks(WidgetRef ref) {
    const uuid = Uuid();
    
    // Create subtask IDs
    final subtaskIds = [
      uuid.v4(),
      uuid.v4(),
      uuid.v4(),
    ];

    // Create a task with subtasks
    final task = Task(
      title: 'Project Planning',
      description: 'Complete project planning phase with all deliverables',
      date: DateTime.now(),
      time: '14:00',
      priority: 'High',
      hasReminder: true,
      subtaskIds: subtaskIds,
    );

    // Add the task
    ref.read(taskListProvider.notifier).addTask(task);
  }
}
