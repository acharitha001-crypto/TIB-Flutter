import 'package:flutter_test/flutter_test.dart';
import 'package:tib/models/study_task.dart';
import 'package:tib/models/subject_score.dart';
import 'package:tib/utils/date_utils.dart';
import 'package:tib/utils/validators.dart';

void main() {
  test('StudyTask JSON round trip keeps all fields', () {
    final t = StudyTask(id: '1', title: 'Lab record', subject: 'Flutter Lab',
        dueDate: DateTime(2026, 11, 12), priority: Priority.high, done: true, note: 'n');
    final back = StudyTask.fromJson(t.toJson());
    expect(back.title, 'Lab record');
    expect(back.priority, Priority.high);
    expect(back.done, isTrue);
    expect(back.dueDate, DateTime(2026, 11, 12));
  });

  test('Unknown priority falls back to medium', () {
    final t = StudyTask.fromJson({'id': '1', 'title': 'x', 'subject': 'DBMS',
        'dueDate': '2026-11-12T00:00:00.000', 'priority': 'urgent'});
    expect(t.priority, Priority.medium);
  });

  test('SubjectScore percentage', () {
    const s = SubjectScore(id: '1', subject: 'OS', exam: 'I1', marks: 27, maxMarks: 30);
    expect(s.percent, closeTo(90, 0.001));
  });

  test('Grade mapping', () {
    expect(gradeFor(92), 'O');
    expect(gradeFor(75), 'A');
    expect(gradeFor(35), 'F');
  });

  test('Due labels', () {
    final now = DateTime(2026, 11, 11, 10);
    expect(dueLabel(DateTime(2026, 11, 11), now: now), 'Today');
    expect(dueLabel(DateTime(2026, 11, 12), now: now), 'Tomorrow');
    expect(dueLabel(DateTime(2026, 11, 8), now: now), 'Overdue · 8 Nov');
  });

  test('Validators', () {
    expect(validateTitle(''), isNotNull);
    expect(validateTitle('Read OS'), isNull);
    expect(validateMarks('35', 30), isNotNull);
    expect(validateMarks('25', 30), isNull);
  });
}
