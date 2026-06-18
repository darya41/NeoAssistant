class MkbCategory {
  final int id;
  final String code;
  final String title;
  final String? parentCode;
  final int level;

  MkbCategory({
    required this.id,
    required this.code,
    required this.title,
    this.parentCode,
    required this.level,
  });

  factory MkbCategory.fromJson(Map<String, dynamic> json) {
    return MkbCategory(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      title: json['title'] ?? '',
      parentCode: json['parent_code'],
      level: json['level'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'parent_code': parentCode,
      'level': level,
    };
  }

  @override
  String toString() {
    return '$code $title';
  }
}