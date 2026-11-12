import 'package:flutter/material.dart';

import '../models/study_task.dart';
import '../state/planner_controller.dart';
import '../utils/date_utils.dart';
import '../utils/validators.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key, required this.controller, this.existing});

  final PlannerController controller;
  final StudyTask? existing;

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _note;
  String? _subject;
  late DateTime _due;
  Priority _priority = Priority.medium;

  bool get _editing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _title = TextEditingController(text: e?.title ?? '');
    _note = TextEditingController(text: e?.note ?? '');
    _subject = e?.subject;
    _due = e?.dueDate ?? dateOnly(DateTime.now());
    _priority = e?.priority ?? Priority.medium;
  }

  @override
  void dispose() {
    _title.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _due,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) setState(() => _due = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final task = StudyTask(
      id: widget.existing?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: _title.text.trim(),
      subject: _subject!,
      dueDate: _due,
      priority: _priority,
      done: widget.existing?.done ?? false,
      note: _note.text.trim(),
    );
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    _editing ? await widget.controller.updateTask(task) : await widget.controller.addTask(task);
    nav.pop();
    messenger.showSnackBar(SnackBar(content: Text(_editing ? 'Task updated' : 'Task added')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_editing ? 'Edit Task' : 'Add Task')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              key: const Key('titleField'),
              controller: _title,
              decoration: const InputDecoration(labelText: 'Task title', border: OutlineInputBorder()),
              validator: validateTitle,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              key: const Key('subjectField'),
              initialValue: _subject,
              decoration: const InputDecoration(labelText: 'Subject', border: OutlineInputBorder()),
              items: [
                for (final s in widget.controller.subjects)
                  DropdownMenuItem(value: s, child: Text(s)),
              ],
              onChanged: (v) => setState(() => _subject = v),
              validator: validateSubject,
            ),
            const SizedBox(height: 16),
            Material(
              type: MaterialType.transparency,
              child: ListTile(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Theme.of(context).colorScheme.outline),
                  borderRadius: BorderRadius.circular(4),
                ),
                leading: const Icon(Icons.event),
                title: const Text('Due date'),
                subtitle: Text(longDate(_due)),
                onTap: _pickDate,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Priority'),
            const SizedBox(height: 8),
            SegmentedButton<Priority>(
              segments: [
                for (final p in Priority.values)
                  ButtonSegment(value: p, label: Text(p.label)),
              ],
              selected: {_priority},
              onSelectionChanged: (s) => setState(() => _priority = s.first),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _note,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Note (optional)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              key: const Key('saveButton'),
              onPressed: _save,
              icon: const Icon(Icons.check),
              label: Text(_editing ? 'Update Task' : 'Save Task'),
            ),
          ],
        ),
      ),
    );
  }
}
