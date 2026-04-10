class Protocol {
  final int? id;
  final String title;
  final String description;

  const Protocol({
    this.id,
    required this.title,
    required this.description,
  });

  factory Protocol.fromJson(Map<String, dynamic> json) {
    return Protocol(
      id: json['id'] as int?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  factory Protocol.fromMap(Map<String, dynamic> map) {
    return Protocol(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}