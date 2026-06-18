import 'package:flutter/material.dart';

import '../../utils/text_formatter.dart';
import 'content_value.dart';

class ContentSection extends StatelessWidget {
  final String sectionKey;
  final dynamic value;

  const ContentSection({
    super.key,
    required this.sectionKey,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    String title = TextFormatter.formatTitle(sectionKey);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        ContentValue(value: value),
      ],
    );
  }
}