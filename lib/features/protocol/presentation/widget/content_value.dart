import 'package:flutter/material.dart';

import '../../utils/text_formatter.dart';

class ContentValue extends StatelessWidget {
  final dynamic value;
  final int indentLevel;

  const ContentValue({
    super.key,
    required this.value,
    this.indentLevel = 0,
  });

  @override
  Widget build(BuildContext context) {
    final leftPadding = indentLevel * 16.0;

    if (value is List) {
      return _buildList(value, leftPadding);
    } else if (value is Map) {
      return _buildMap(value, leftPadding);
    } else {
      return _buildPrimitive(value, leftPadding);
    }
  }

  Widget _buildList(List list, double leftPadding) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list.map((item) {
        if (item is Map) {
          return Padding(
            padding: EdgeInsets.only(left: leftPadding, top: 8),
            child: ContentValue(value: item, indentLevel: indentLevel + 1),
          );
        } else {
          return Padding(
            padding: EdgeInsets.only(left: leftPadding + 16, bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Text(
                    item.toString(),
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ],
            ),
          );
        }
      }).toList(),
    );
  }

  Widget _buildMap(Map map, double leftPadding) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: map.entries.map((entry) {
        return Padding(
          padding: EdgeInsets.only(left: leftPadding, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                TextFormatter.formatTitle(entry.key),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              ContentValue(
                value: entry.value,
                indentLevel: indentLevel + 1,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPrimitive(dynamic value, double leftPadding) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding + 16, bottom: 8),
      child: Text(
        value.toString(),
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }
}