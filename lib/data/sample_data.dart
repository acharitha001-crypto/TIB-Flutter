import '../models/study_task.dart';
import '../models/subject_score.dart';

const kSubjects = [
  'Flutter Lab',
  'DBMS',
  'Operating Systems',
  'Computer Networks',
  'Software Engineering',
];

List<StudyTask> sampleTasks(DateTime now) {
  DateTime d(int days) => DateTime(now.year, now.month, now.day + days);
  return [
    StudyTask(id: 't1', title: 'Flutter Lab record – Week 6', subject: 'Flutter Lab', dueDate: d(0), priority: Priority.high),
    StudyTask(id: 't2', title: 'Revise normalization (1NF–BCNF)', subject: 'DBMS', dueDate: d(0)),
    StudyTask(id: 't3', title: 'CN assignment – subnetting', subject: 'Computer Networks', dueDate: d(1), priority: Priority.high),
    StudyTask(id: 't4', title: 'Read OS deadlock chapter', subject: 'Operating Systems', dueDate: d(2), priority: Priority.low),
    StudyTask(id: 't5', title: 'SE case study – UML diagrams', subject: 'Software Engineering', dueDate: d(4)),
    StudyTask(id: 't6', title: 'Practice SQL joins', subject: 'DBMS', dueDate: d(-1), done: true),
    StudyTask(id: 't7', title: 'Flutter widget tree notes', subject: 'Flutter Lab', dueDate: d(-2), done: true),
  ];
}

List<SubjectScore> sampleScores() => const [
      SubjectScore(id: 's1', subject: 'Flutter Lab', exam: 'Internal 1', marks: 27, maxMarks: 30),
      SubjectScore(id: 's2', subject: 'DBMS', exam: 'Internal 1', marks: 22, maxMarks: 30),
      SubjectScore(id: 's3', subject: 'Operating Systems', exam: 'Internal 1', marks: 19, maxMarks: 30),
      SubjectScore(id: 's4', subject: 'Computer Networks', exam: 'Internal 1', marks: 24, maxMarks: 30),
      SubjectScore(id: 's5', subject: 'Software Engineering', exam: 'Internal 1', marks: 25, maxMarks: 30),
      SubjectScore(id: 's6', subject: 'Flutter Lab', exam: 'Assignment 1', marks: 9, maxMarks: 10),
      SubjectScore(id: 's7', subject: 'Operating Systems', exam: 'Assignment 1', marks: 6, maxMarks: 10),
    ];
