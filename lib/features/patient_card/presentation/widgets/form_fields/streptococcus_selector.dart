import 'package:flutter/material.dart';
import 'package:neo_friend/core/constants/app_colors.dart';

class StreptococcusSelector extends StatelessWidget {
  final String? selectedValue;
  final Function(String) onSelected;

  final List<String> _options = ['положительный', 'отрицательный', 'неизвестный'];

  StreptococcusSelector({
    super.key,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Статусы стрептококка группы В (СГВ):',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _options.map((option) {
              final isSelected = selectedValue == option;
              return GestureDetector(
                onTap: () => onSelected(option),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.brand_40 : AppColors.neutral_5,
                    border: Border.all(color: AppColors.neutral_25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      color: isSelected ? AppColors.neutral_0 : AppColors.neutral_90,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}