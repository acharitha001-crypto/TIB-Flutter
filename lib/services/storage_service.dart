import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/study_task.dart';
import '../models/subject_score.dart';

/// Saves tasks, scores and settings on the device with shared_preferences.
class StorageService {
  static const _tasksKey = 'tib_tasks';
  static const _scoresKey = 'tib_scores';
  static const _targetKey = 'tib_target';
  static const _darkKey = 'tib_dark';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<List<StudyTask>> loadTasks() async {
    final raw = (await _prefs).getString(_tasksKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((e) => StudyTask.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<SubjectScore>> loadScores() async {
    final raw = (await _prefs).getString(_scoresKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((e) => SubjectScore.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<double> loadTarget() async =>
      (await _prefs).getDouble(_targetKey) ?? 75;

  Future<bool> loadDarkMode() async =>
      (await _prefs).getBool(_darkKey) ?? false;

  Future<void> saveTasks(List<StudyTask> tasks) async => (await _prefs)
      .setString(_tasksKey, jsonEncode(tasks.map((t) => t.toJson()).toList()));

  Future<void> saveScores(List<SubjectScore> scores) async =>
      (await _prefs).setString(
          _scoresKey, jsonEncode(scores.map((s) => s.toJson()).toList()));

  Future<void> saveTarget(double value) async =>
      (await _prefs).setDouble(_targetKey, value);

  Future<void> saveDarkMode(bool value) async =>
      (await _prefs).setBool(_darkKey, value);

  Future<void> clear() async => (await _prefs).clear();
}
