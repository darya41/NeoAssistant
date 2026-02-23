class Protocol {
  final String title;
  final String description;
  final bool hasPDF;
  final bool hasDOC;

  const Protocol({
    required this.title,
    required this.description,
    required this.hasPDF,
    required this.hasDOC,
  });

  factory Protocol.fromMap(Map<String, dynamic> map) {
    return Protocol(
      title: map['title'] as String,
      description: map['description'] as String,
      hasPDF: map['hasPDF'] as bool? ?? false,
      hasDOC: map['hasDOC'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'hasPDF': hasPDF,
      'hasDOC': hasDOC,
    };
  }
}
