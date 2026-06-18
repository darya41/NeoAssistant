import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/medical_parameter.dart';

class ParameterField extends StatelessWidget {
  final MedicalParameter param;
  final dynamic value;
  final Function(dynamic) onChanged;

  const ParameterField({
    super.key,
    required this.param,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            param.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),

          if (param.valueType == 'enum' && param.options != null)
            _buildEnumField()
          else
            _buildTextField(),
        ],
      ),
    );
  }

  Widget _buildEnumField() {
    final options = param.options!;

    if (options.length <= 4) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: options.map((option) {
          final isSelected = value == option;

          return GestureDetector(
            onTap: () => onChanged(option),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.brand_40 : AppColors.neutral_5,
                border: Border.all(
                  color: isSelected ? AppColors.brand_40 : AppColors.neutral_25,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                option,
                style: TextStyle(
                  color: isSelected ? AppColors.neutral_0 : AppColors.neutral_90,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }).toList(),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.neutral_5,
        border: Border.all(color: AppColors.neutral_25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: value,
        hint: const Text('Выберите значение'),
        isExpanded: true,
        underline: Container(),
        items: options.map((option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: (newValue) => onChanged(newValue),
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.neutral_5,
        border: Border.all(color: AppColors.neutral_25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        keyboardType: param.valueType == 'number'
            ? TextInputType.number
            : TextInputType.text,
        decoration: InputDecoration(
          hintText: param.unit != null
              ? 'Введите значение (${param.unit})'
              : 'Введите значение',
          border: InputBorder.none,
          isDense: true,
        ),
        onChanged: (newValue) => onChanged(newValue),
      ),
    );
  }
}