class ProtocolHierarchy {
  final int id;
  final int protocolDocumentId;
  final int? techLevelId;
  final int? parentId;
  final String? title;
  final int level;
  final int sortOrder;
  final String? content;
  final List<ProtocolHierarchy> children;

  ProtocolHierarchy({
    required this.id,
    required this.protocolDocumentId,
    this.techLevelId,
    this.parentId,
    this.title,
    required this.level,
    required this.sortOrder,
    this.content,
    this.children = const [],
  });

  factory ProtocolHierarchy.fromJson(Map<String, dynamic> json) {
    return ProtocolHierarchy(
      id: json['id'],
      protocolDocumentId: json['protocol_document_id'],
      techLevelId: json['tech_level_id'],
      parentId: json['parent_id'],
      title: json['title'],
      level: json['level'],
      sortOrder: json['sort_order'],
      content: json['content'],
    );
  }

  ProtocolHierarchy copyWith({
    int? id,
    int? protocolDocumentId,
    int? techLevelId,
    int? parentId,
    String? title,
    int? level,
    int? sortOrder,
    String? content,
    List<ProtocolHierarchy>? children,
  }) {
    return ProtocolHierarchy(
      id: id ?? this.id,
      protocolDocumentId: protocolDocumentId ?? this.protocolDocumentId,
      techLevelId: techLevelId ?? this.techLevelId,
      parentId: parentId ?? this.parentId,
      title: title ?? this.title,
      level: level ?? this.level,
      sortOrder: sortOrder ?? this.sortOrder,
      content: content ?? this.content,
      children: children ?? this.children,
    );
  }
  bool get isChapter => level == 1;
  bool get isSection => level == 2;
  bool get hasChildren => children.isNotEmpty;
}