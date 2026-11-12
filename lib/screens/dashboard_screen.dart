import 'package:flutter/material.dart';

import '../state/planner_controller.dart';
import '../widgets/empty_state.dart';
import '../widgets/stat_tile.dart';
import '../widgets/summary_card.dart';
import '../widgets/task_tile.dart';
import 'add_task_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.controller});

  final PlannerController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final today = controller.todayTasks();
        final weak = controller.weakSubjects;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            Text('Hello, Student 👋',
                style: Theme.of(context).textTheme.headlineSmall),
            const Text('Plan today, perform better tomorrow.'),
            const SizedBox(height: 16),
            SummaryCard(
              completionRate: controller.completionRate,
              pending: controller.pendingCount,
              overall: controller.overallPercent,
            ),
            const SizedBox(height: 12),
            Row(children: [
              StatTile(icon: Icons.task_alt, label: 'Done', value: '${controller.completedCount}'),
              StatTile(icon: Icons.menu_book, label: 'Subjects', value: '${controller.subjectAverages().length}'),
              StatTile(icon: Icons.flag, label: 'Target', value: '${controller.targetPercent.round()}%'),
            ]),
            if (weak.isNotEmpty) ...[
              const SizedBox(height: 8),
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: ListTile(
                  leading: const Icon(Icons.warning_amber),
                  title: const Text('Needs attention'),
                  subtitle: Text(weak.join(', ')),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text("Today's focus", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            if (today.isEmpty)
              const EmptyState(
                  icon: Icons.celebration_outlined,
                  message: 'No tasks due today.\nTap “Add Task” to plan your study.')
            else
              for (final t in today)
                TaskTile(
                  task: t,
                  onToggle: () => controller.toggleDone(t.id),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => AddTaskScreen(controller: controller, existing: t))),
                ),
          ],
        );
      },
    );
  }
}
