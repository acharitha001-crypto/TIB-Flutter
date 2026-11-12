import 'package:flutter/material.dart';

import '../models/study_task.dart';
import '../utils/date_utils.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    this.onTap,
  });

  final StudyTask task;
  final VoidCallback onToggle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final overdue = !task.done &&
        dateOnly(task.dueDate).isBefore(dateOnly(DateTime.now()));
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(value: task.done, onChanged: (_) => onToggle()),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.done ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('${task.subject} · ${task.done ? 'Completed' : dueLabel(task.dueDate)}',
            style: TextStyle(color: overdue ? Colors.red : null)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: task.priority.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(task.priority.label,
              style: TextStyle(color: task.priority.color, fontSize: 12)),
        ),
      ),
    );
  }
}
