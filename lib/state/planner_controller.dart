import 'package:flutter/foundation.dart';

import '../data/sample_data.dart';
import '../models/study_task.dart';
import '../models/subject_score.dart';
import '../services/storage_service.dart';
import '../utils/date_utils.dart';

/// Single source of truth for tasks, scores and settings.
class PlannerController extends ChangeNotifier {
  PlannerController(this._storage);

  final StorageService _storage;

  List<StudyTask> _tasks = [];
  List<SubjectScore> _scores = [];
  double targetPercent = 75;
  bool darkMode = false;

  List<StudyTask> get tasks => List.unmodifiable(_tasks);
  List<SubjectScore> get scores => List.unmodifiable(_scores);

  Future<void> load() async {
    _tasks = await _storage.loadTasks();
    _scores = await _storage.loadScores();
    targetPercent = await _storage.loadTarget();
    darkMode = await _storage.loadDarkMode();
    notifyListeners();
  }

  // ---------- Tasks ----------
  Future<void> addTask(StudyTask task) async {
    _tasks = [..._tasks, task];
    await _saveTasks();
  }

  Future<void> updateTask(StudyTask task) async {
    _tasks = [for (final t in _tasks) t.id == task.id ? task : t];
    await _saveTasks();
  }

  Future<void> toggleDone(String id) async {
    _tasks = [
      for (final t in _tasks) t.id == id ? t.copyWith(done: !t.done) : t
    ];
    await _saveTasks();
  }

  Future<void> deleteTask(String id) async {
    _tasks = _tasks.where((t) => t.id != id).toList();
    await _saveTasks();
  }

  /// Pending tasks first (earliest due date first), then completed ones.
  List<StudyTask> filteredTasks({String query = '', String? subject}) {
    final q = query.trim().toLowerCase();
    final list = _tasks.where((t) {
      final matchesText = q.isEmpty ||
          t.title.toLowerCase().contains(q) ||
          t.subject.toLowerCase().contains(q);
      return matchesText && (subject == null || t.subject == subject);
    }).toList()
      ..sort((a, b) {
        if (a.done != b.done) return a.done ? 1 : -1;
        return a.dueDate.compareTo(b.dueDate);
      });
    return list;
  }

  List<StudyTask> todayTasks([DateTime? now]) {
    final today = dateOnly(now ?? DateTime.now());
    return _tasks
        .where((t) => !t.done && !dateOnly(t.dueDate).isAfter(today))
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  int get completedCount => _tasks.where((t) => t.done).length;
  int get pendingCount => _tasks.length - completedCount;
  double get completionRate =>
      _tasks.isEmpty ? 0 : completedCount / _tasks.length;

  List<String> get subjects {
    final set = <String>{...kSubjects};
    for (final t in _tasks) {
      set.add(t.subject);
    }
    for (final s in _scores) {
      set.add(s.subject);
    }
    return set.toList();
  }

  // ---------- Performance ----------
  Future<void> addScore(SubjectScore score) async {
    _scores = [..._scores, score];
    await _storage.saveScores(_scores);
    notifyListeners();
  }

  Future<void> deleteScore(String id) async {
    _scores = _scores.where((s) => s.id != id).toList();
    await _storage.saveScores(_scores);
    notifyListeners();
  }

  /// Average percentage per subject, highest first.
  Map<String, double> subjectAverages() {
    final sums = <String, double>{};
    final max = <String, double>{};
    for (final s in _scores) {
      sums[s.subject] = (sums[s.subject] ?? 0) + s.marks;
      max[s.subject] = (max[s.subject] ?? 0) + s.maxMarks;
    }
    final result = {
      for (final k in sums.keys) k: max[k]! == 0 ? 0.0 : sums[k]! / max[k]! * 100
    };
    final sorted = result.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(sorted);
  }

  double get overallPercent {
    final marks = _scores.fold<double>(0, (a, s) => a + s.marks);
    final max = _scores.fold<double>(0, (a, s) => a + s.maxMarks);
    return max == 0 ? 0 : marks / max * 100;
  }

  List<String> get weakSubjects => subjectAverages()
      .entries
      .where((e) => e.value < targetPercent)
      .map((e) => e.key)
      .toList();

  // ---------- Settings ----------
  Future<void> setTarget(double value) async {
    targetPercent = value;
    await _storage.saveTarget(value);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    darkMode = value;
    await _storage.saveDarkMode(value);
    notifyListeners();
  }

  Future<void> loadDemoData() async {
    _tasks = sampleTasks(DateTime.now());
    _scores = sampleScores();
    await _storage.saveScores(_scores);
    await _saveTasks();
  }

  Future<void> clearAll() async {
    _tasks = [];
    _scores = [];
    await _storage.saveScores(_scores);
    await _saveTasks();
  }

  Future<void> _saveTasks() async {
    await _storage.saveTasks(_tasks);
    notifyListeners();
  }
}
