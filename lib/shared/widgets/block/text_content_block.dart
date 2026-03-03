import 'package:flutter/material.dart';

class TextContentBlock extends StatelessWidget {
  final String title;
  final String description;

  const TextContentBlock({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          description,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
