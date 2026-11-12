import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tib/models/study_task.dart';
import 'package:tib/models/subject_score.dart';
import 'package:tib/services/storage_service.dart';
import 'package:tib/state/planner_controller.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  StudyTask task(String id, {bool done = false}) => StudyTask(
      id: id, title: 'Task $id', subject: 'DBMS', dueDate: DateTime(2026, 11, 11), done: done);

  test('add, toggle and delete tasks update completion rate', () async {
    final c = PlannerController(StorageService());
    await c.addTask(task('a'));
    await c.addTask(task('b'));
    await c.toggleDone('a');
    expect(c.completionRate, 0.5);
    await c.deleteTask('b');
    expect(c.tasks.length, 1);
    expect(c.completionRate, 1);
  });

  test('subject averages are sorted and weak subjects detected', () async {
    final c = PlannerController(StorageService());
    await c.addScore(const SubjectScore(id: '1', subject: 'OS', exam: 'I1', marks: 15, maxMarks: 30));
    await c.addScore(const SubjectScore(id: '2', subject: 'DBMS', exam: 'I1', marks: 27, maxMarks: 30));
    expect(c.subjectAverages().keys.first, 'DBMS');
    expect(c.weakSubjects, ['OS']);
    expect(c.overallPercent, closeTo(70, 0.001));
  });

  test('data is persisted and reloaded', () async {
    final c = PlannerController(StorageService());
    await c.addTask(task('a'));
    await c.setTarget(80);
    final again = PlannerController(StorageService());
    await again.load();
    expect(again.tasks.single.title, 'Task a');
    expect(again.targetPercent, 80);
  });

  test('search and subject filter', () async {
    final c = PlannerController(StorageService());
    await c.loadDemoData();
    expect(c.filteredTasks(query: 'sql').length, 1);
    expect(c.filteredTasks(subject: 'Flutter Lab').length, 2);
  });
}
