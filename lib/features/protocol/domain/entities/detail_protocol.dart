import 'dart:convert';

class DetailProtocol {
  final int? id;
  final int protocolId;
  final String title;
  final Map<String, dynamic> content;

  DetailProtocol({
    this.id,
    required this.protocolId,
    required this.title,
    required this.content,
  });

  factory DetailProtocol.fromJson(Map<String, dynamic> json) {
    return DetailProtocol(
      id: json['id'] as int?,
      protocolId: json['protocol_id'] as int,
      title: json['title'] as String? ?? '',
      content: json['content'] is String
          ? jsonDecode(json['content']) as Map<String, dynamic>
          : (json['content'] as Map<String, dynamic>?) ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'protocol_id': protocolId,
      'title': title,
      'content': jsonEncode(content),
    };
  }
}