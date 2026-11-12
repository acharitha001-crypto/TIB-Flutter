import 'package:flutter/material.dart';

import '../state/planner_controller.dart';
import '../widgets/empty_state.dart';
import '../widgets/task_tile.dart';
import 'add_task_screen.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key, required this.controller});

  final PlannerController controller;

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  String _query = '';
  String? _subject;

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    return ListenableBuilder(
      listenable: c,
      builder: (context, _) {
        final list = c.filteredTasks(query: _query, subject: _subject);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search tasks or subjects',
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: ChoiceChip(
                      label: const Text('All'),
                      selected: _subject == null,
                      onSelected: (_) => setState(() => _subject = null),
                    ),
                  ),
                  for (final s in c.subjects)
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: ChoiceChip(
                        label: Text(s),
                        selected: _subject == s,
                        onSelected: (_) => setState(() => _subject = s),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: list.isEmpty
                  ? const EmptyState(icon: Icons.event_note, message: 'No tasks found')
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                      children: [
                        for (final t in list)
                          Dismissible(
                            key: ValueKey(t.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              color: Colors.red,
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (_) {
                              c.deleteTask(t.id);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Deleted “${t.title}”'),
                                action: SnackBarAction(label: 'UNDO', onPressed: () => c.addTask(t)),
                              ));
                            },
                            child: TaskTile(
                              task: t,
                              onToggle: () => c.toggleDone(t.id),
                              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => AddTaskScreen(controller: c, existing: t))),
                            ),
                          ),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }
}
