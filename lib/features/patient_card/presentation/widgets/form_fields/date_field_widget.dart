import 'package:flutter/material.dart';

class DateFieldWidget extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;
  final String hintText;
  final String? errorText;
  final bool showError;

  static const _defaultBackgroundColor = Color(0xFFF3F3F3);
  static const _borderColor = Color(0xFFC6C6C6);
  static const _errorBorderColor = Colors.red;

  const DateFieldWidget({
    super.key,
    required this.selectedDate,
    required this.onTap,
    this.hintText = 'Дата рождения*',
    this.errorText,
    this.showError = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = showError && errorText != null
        ? _errorBorderColor
        : _borderColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _defaultBackgroundColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                selectedDate == null
                    ? hintText
                    : '${selectedDate!.day}.${selectedDate!.month}.${selectedDate!.year}',
                style: TextStyle(
                  color: selectedDate == null ? Colors.grey : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}