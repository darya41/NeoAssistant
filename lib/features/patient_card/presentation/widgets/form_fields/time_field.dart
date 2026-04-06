import 'package:flutter/material.dart';
import 'package:neo_friend/core/constants/app_colors.dart';

class TimeField extends StatelessWidget {
  final String timeDisplay;
  final VoidCallback onTap;
  final String? hintText;

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
          color: AppColors.background,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time),
            const SizedBox(width: 8),
            Text(
              displayText,
              style: TextStyle(
                color: timeDisplay.isEmpty ? AppColors.grey : AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}