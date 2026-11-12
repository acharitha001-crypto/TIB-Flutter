const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Returns "Today", "Tomorrow", "Yesterday", "Overdue · 3 Nov" or "14 Nov".
String dueLabel(DateTime due, {DateTime? now}) {
  final today = dateOnly(now ?? DateTime.now());
  final diff = dateOnly(due).difference(today).inDays;
  final short = '${due.day} ${_months[due.month - 1]}';
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Tomorrow';
  if (diff == -1) return 'Yesterday';
  if (diff < 0) return 'Overdue · $short';
  return short;
}

String longDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';
