import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class DateField extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;
  final String hintText;
  final String? errorText;
  final bool showError;

  const DateField({
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
        ? AppColors.error
        : AppColors.neutral_25;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.neutral_5,
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
                  color: selectedDate == null ? AppColors.neutral_50 : AppColors.neutral_90,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}