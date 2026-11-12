import 'package:flutter/material.dart';

enum Priority { low, medium, high }

extension PriorityX on Priority {
  String get label => name[0].toUpperCase() + name.substring(1);

  Color get color => switch (this) {
        Priority.low => Colors.green,
        Priority.medium => Colors.orange,
        Priority.high => Colors.red,
      };
}

/// A planned academic task such as an assignment, revision or lab record.
class StudyTask {
  const StudyTask({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    this.priority = Priority.medium,
    this.done = false,
    this.note = '',
  });

  final String id;
  final String title;
  final String subject;
  final DateTime dueDate;
  final Priority priority;
  final bool done;
  final String note;

  StudyTask copyWith({
    String? title,
    String? subject,
    DateTime? dueDate,
    Priority? priority,
    bool? done,
    String? note,
  }) =>
      StudyTask(
        id: id,
        title: title ?? this.title,
        subject: subject ?? this.subject,
        dueDate: dueDate ?? this.dueDate,
        priority: priority ?? this.priority,
        done: done ?? this.done,
        note: note ?? this.note,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subject': subject,
        'dueDate': dueDate.toIso8601String(),
        'priority': priority.name,
        'done': done,
        'note': note,
      };

  factory StudyTask.fromJson(Map<String, dynamic> json) => StudyTask(
        id: json['id'] as String,
        title: json['title'] as String,
        subject: json['subject'] as String,
        dueDate: DateTime.parse(json['dueDate'] as String),
        priority: Priority.values.firstWhere(
          (p) => p.name == json['priority'],
          orElse: () => Priority.medium,
        ),
        done: json['done'] as bool? ?? false,
        note: json['note'] as String? ?? '',
      );
}
