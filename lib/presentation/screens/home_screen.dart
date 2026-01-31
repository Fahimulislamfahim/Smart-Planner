import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../features/tasks/task_providers.dart';
import '../widgets/task_list_item.dart';
import '../widgets/assistant_header.dart';
import 'add_task_screen.dart';
import 'insights_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // We can pre-fetch data if needed, but the provider does it on init.
    // final allTasks = ref.watch(taskListProvider);

    final tabs = [
       const _TaskTabs(),
       const InsightsScreen(),
    ];

    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart),
            label: 'Insights',
          ),
        ],
      ),
    );
  }
}

class _TaskTabs extends StatelessWidget {
  const _TaskTabs();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Smart Planner',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                DateFormat.yMMMMEEEEd().format(DateTime.now()),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
              ),
            ],
          ),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Today'),
              Tab(text: 'Tomorrow'),
              Tab(text: 'Upcoming'),
              Tab(text: 'Completed'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Settings Screen
              },
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            Column(
              children: [
                AssistantHeader(),
                Expanded(child: TaskListView(providerType: 'today')),
              ],
            ),
            TaskListView(providerType: 'tomorrow'),
            TaskListView(providerType: 'upcoming'),
            TaskListView(providerType: 'completed'),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddTaskScreen()),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('New Task'),
        ),
      ),
    );
  }
}

class TaskListView extends ConsumerWidget {
  final String providerType;

  const TaskListView({super.key, required this.providerType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = switch (providerType) {
      'today' => ref.watch(todayTasksProvider),
      'tomorrow' => ref.watch(tomorrowTasksProvider),
      'upcoming' => ref.watch(upcomingTasksProvider),
      'completed' => ref.watch(completedTasksProvider),
      _ => [],
    };

    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_note, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No tasks found',
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 80),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskListItem(task: task);
      },
    );
  }
}
