String? validateTitle(String? value) {
  final v = value?.trim() ?? '';
  if (v.isEmpty) return 'Please enter a task title';
  if (v.length < 3) return 'Title must be at least 3 characters';
  return null;
}

String? validateSubject(String? value) =>
    (value == null || value.trim().isEmpty) ? 'Please choose a subject' : null;

String? validateMarks(String? value, double maxMarks) {
  final n = double.tryParse(value?.trim() ?? '');
  if (n == null) return 'Enter valid marks';
  if (n < 0 || n > maxMarks) return 'Marks must be 0 – ${maxMarks.toInt()}';
  return null;
}

/// Converts a percentage to a letter grade (10-point style).
String gradeFor(double percent) {
  if (percent >= 90) return 'O';
  if (percent >= 80) return 'A+';
  if (percent >= 70) return 'A';
  if (percent >= 60) return 'B+';
  if (percent >= 50) return 'B';
  if (percent >= 40) return 'C';
  return 'F';
}
