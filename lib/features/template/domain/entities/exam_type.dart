class ExamType {
  final int examTypeId;
  final String name;

  ExamType({
    required this.examTypeId,
    required this.name,
  });

  factory ExamType.fromJson(Map<String, dynamic> json) {
    return ExamType(
      examTypeId: json['exam_type_id'] ?? json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exam_type_id': examTypeId,
      'name': name,
    };
  }
}