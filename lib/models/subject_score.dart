/// Marks obtained by the student in one exam / assessment of a subject.
class SubjectScore {
  const SubjectScore({
    required this.id,
    required this.subject,
    required this.exam,
    required this.marks,
    required this.maxMarks,
  });

  final String id;
  final String subject;
  final String exam;
  final double marks;
  final double maxMarks;

  double get percent => maxMarks == 0 ? 0 : marks / maxMarks * 100;

  Map<String, dynamic> toJson() => {
        'id': id,
        'subject': subject,
        'exam': exam,
        'marks': marks,
        'maxMarks': maxMarks,
      };

  factory SubjectScore.fromJson(Map<String, dynamic> json) => SubjectScore(
        id: json['id'] as String,
        subject: json['subject'] as String,
        exam: json['exam'] as String,
        marks: (json['marks'] as num).toDouble(),
        maxMarks: (json['maxMarks'] as num).toDouble(),
      );
}
