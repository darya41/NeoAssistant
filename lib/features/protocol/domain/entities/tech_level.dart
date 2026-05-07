class TechLevel {
  final int id;
  final String name;
  final int priority;

  const TechLevel({
    required this.id,
    required this.name,
    required this.priority,
  });

  factory TechLevel.fromJson(Map<String, dynamic> json) {
    return TechLevel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      priority: json['priority'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'priority': priority,
    };
  }

  String get description {
    switch (id) {
      case 1:
        return 'Базовый уровень - первичная медицинская помощь';
      case 2:
        return 'Расширенный уровень - межрайонные центры';
      case 3:
        return 'Областной уровень - специализированная помощь';
      case 4:
        return 'Высший уровень - высокотехнологичная помощь';
      default:
        return '';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TechLevel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}