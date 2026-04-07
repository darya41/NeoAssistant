import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/filter.dart';

class BloodTypeSelector extends StatelessWidget {
  final String? selectedBloodGroup;
  final String? selectedRhFactor;
  final Function(String?) onBloodGroupChanged;
  final Function(String?) onRhFactorChanged;
  final bool showValidationErrors;
  final String? bloodGroupError;
  final String? rhFactorError;

  const BloodTypeSelector({
    super.key,
    required this.selectedBloodGroup,
    required this.selectedRhFactor,
    required this.onBloodGroupChanged,
    required this.onRhFactorChanged,
    this.showValidationErrors = false,
    this.bloodGroupError,
    this.rhFactorError,
  });

  String _getBloodGroupDescription(String group) {
    switch (group) {
      case 'A':
        return 'II';
      case 'B':
        return 'III';
      case 'AB':
        return 'IV';
      case 'O':
        return 'I';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Группа крови и резус-фактор:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Группа крови',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      border: Border.all(
                        color: (showValidationErrors && bloodGroupError != null)
                            ? AppColors.error
                            : AppColors.border,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: selectedBloodGroup,
                      hint: const Text('Выберите группу'),
                      isExpanded: true,
                      underline: Container(),
                      items: Filter.bloodGroups.map((group) {
                        return DropdownMenuItem<String>(
                          value: group,
                          child: Text('$group (${_getBloodGroupDescription(group)})'),
                        );
                      }).toList(),
                      onChanged: onBloodGroupChanged,
                    ),
                  ),
                  if (showValidationErrors && bloodGroupError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        bloodGroupError!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Резус-фактор',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      border: Border.all(
                        color: (showValidationErrors && rhFactorError != null)
                            ? AppColors.error
                            : AppColors.border,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: selectedRhFactor,
                      hint: const Text('Rh'),
                      isExpanded: true,
                      underline: Container(),
                      items: Filter.rhFactors.map((rh) {
                        return DropdownMenuItem<String>(
                          value: rh,
                          child: Text('Rh$rh'),
                        );
                      }).toList(),
                      onChanged: onRhFactorChanged,
                    ),
                  ),
                  if (showValidationErrors && rhFactorError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        rhFactorError!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}