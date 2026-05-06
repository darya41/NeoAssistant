class DiagnosticTest {
  final int id;
  final String name;
  final String type;
  final String? description;

  DiagnosticTest({
    required this.id,
    required this.name,
    required this.type,
    this.description,
  });

  factory DiagnosticTest.fromJson(Map<String, dynamic> json) {
    return DiagnosticTest(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
    };
  }
}