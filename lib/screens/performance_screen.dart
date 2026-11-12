import 'package:flutter/material.dart';

import '../models/subject_score.dart';
import '../state/planner_controller.dart';
import '../utils/validators.dart';
import '../widgets/empty_state.dart';
import '../widgets/score_bar_chart.dart';

class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key, required this.controller});

  final PlannerController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final avg = controller.subjectAverages();
        final overall = controller.overallPercent;
        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _addScore(context),
            icon: const Icon(Icons.add_chart),
            label: const Text('Add Marks'),
          ),
          body: avg.isEmpty
              ? const EmptyState(icon: Icons.insights, message: 'No marks yet.\nAdd your exam marks to track performance.')
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                  children: [
                    Text('Performance', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 12),
                    Card(
                      child: ListTile(
                        leading: CircleAvatar(child: Text(gradeFor(overall))),
                        title: Text('Overall ${overall.toStringAsFixed(1)}%'),
                        subtitle: Text('Target ${controller.targetPercent.round()}% · '
                            '${overall >= controller.targetPercent ? 'On track' : 'Below target'}'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('Subject averages', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ScoreBarChart(data: avg, target: controller.targetPercent),
                    const SizedBox(height: 16),
                    Text('All assessments', style: Theme.of(context).textTheme.titleMedium),
                    for (final s in controller.scores)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('${s.subject} – ${s.exam}'),
                        subtitle: Text('${s.marks.toStringAsFixed(0)} / ${s.maxMarks.toStringAsFixed(0)}'),
                        trailing: Text('${s.percent.round()}%  ${gradeFor(s.percent)}',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        onLongPress: () => controller.deleteScore(s.id),
                      ),
                  ],
                ),
        );
      },
    );
  }

  Future<void> _addScore(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final exam = TextEditingController(text: 'Internal 1');
    final marks = TextEditingController();
    String subject = controller.subjects.first;
    double maxMarks = 30;
    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Add Marks'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: subject,
                  decoration: const InputDecoration(labelText: 'Subject'),
                  items: [for (final s in controller.subjects) DropdownMenuItem(value: s, child: Text(s))],
                  onChanged: (v) => setState(() => subject = v!),
                ),
                TextFormField(controller: exam, decoration: const InputDecoration(labelText: 'Exam')),
                TextFormField(
                  controller: marks,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Marks (out of ${maxMarks.toInt()})'),
                  validator: (v) => validateMarks(v, maxMarks),
                ),
                DropdownButtonFormField<double>(
                  initialValue: maxMarks,
                  decoration: const InputDecoration(labelText: 'Maximum marks'),
                  items: const [10.0, 30.0, 50.0, 100.0]
                      .map((m) => DropdownMenuItem(value: m, child: Text('${m.toInt()}')))
                      .toList(),
                  onChanged: (v) => setState(() => maxMarks = v!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                controller.addScore(SubjectScore(
                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                  subject: subject,
                  exam: exam.text.trim().isEmpty ? 'Exam' : exam.text.trim(),
                  marks: double.parse(marks.text.trim()),
                  maxMarks: maxMarks,
                ));
                Navigator.pop(ctx);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
