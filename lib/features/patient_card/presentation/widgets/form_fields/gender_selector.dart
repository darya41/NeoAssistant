import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class GenderSelector extends StatelessWidget {
  final String selectedGender;
  final Function(String) onGenderSelected;

  const GenderSelector({
    super.key,
    required this.selectedGender,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Пол ребёнка:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildRadioOption('мужской', 'Мужской'),
            const SizedBox(width: 16),
            _buildRadioOption('женский', 'Женский'),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioOption(String value, String label) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: selectedGender,
          activeColor: AppColors.primary,
          onChanged: (selected) {
            if (selected != null) {
              onGenderSelected(selected);
            }
          },
        ),
        Text(label),
      ],
    );
  }
}