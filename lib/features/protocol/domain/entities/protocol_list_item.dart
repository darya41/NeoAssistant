class ProtocolListItem {
  final int protocolDocumentId;
  final String protocolTitle;
  final int hierarchyId;
  final String hierarchyTitle;
  final int level;
  final int? parentId;
  final String? content;

  ProtocolListItem({
    required this.protocolDocumentId,
    required this.protocolTitle,
    required this.hierarchyId,
    required this.hierarchyTitle,
    required this.level,
    this.parentId,
    this.content,
  });

  String get displayTitle => '$protocolTitle: $hierarchyTitle';

  factory ProtocolListItem.fromJson(Map<String, dynamic> json) {
    return ProtocolListItem(
      protocolDocumentId: json['protocol_document_id'],
      protocolTitle: json['protocol_title'],
      hierarchyId: json['hierarchy_id'],
      hierarchyTitle: json['hierarchy_title'],
      level: json['level'],
      parentId: json['parent_id'],
      content: json['content'],
    );
  }
}