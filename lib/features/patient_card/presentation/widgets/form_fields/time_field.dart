import 'package:flutter/material.dart';

class TimeField extends StatelessWidget {
  final String timeDisplay;
  final VoidCallback onTap;
  final String? hintText;

  static const _defaultBackgroundColor = Color(0xFFF3F3F3);
  static const _borderColor = Color(0xFFC6C6C6);

  const TimeField({
    super.key,
    required this.timeDisplay,
    required this.onTap,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = timeDisplay.isEmpty
        ? (hintText ?? 'Выберите время')
        : timeDisplay;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _defaultBackgroundColor,
          border: Border.all(color: _borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time),
            const SizedBox(width: 8),
            Text(
              displayText,
              style: TextStyle(
                color: timeDisplay.isEmpty ? Colors.grey : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}