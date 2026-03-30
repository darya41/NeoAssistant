import 'package:flutter/material.dart';

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

  static const List<String> _bloodGroups = ['A', 'B', 'AB', 'O'];
  static const List<String> _rhFactors = ['+', '-'];

  static const _defaultBackgroundColor = Color(0xFFF3F3F3);
  static const _borderColor = Color(0xFFC6C6C6);

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
                      color: _defaultBackgroundColor,
                      border: Border.all(
                        color: (showValidationErrors && bloodGroupError != null)
                            ? Colors.red
                            : _borderColor,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: selectedBloodGroup,
                      hint: const Text('Выберите группу'),
                      isExpanded: true,
                      underline: Container(),
                      items: _bloodGroups.map((group) {
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
                          color: Colors.red,
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
                      color: _defaultBackgroundColor,
                      border: Border.all(
                        color: (showValidationErrors && rhFactorError != null)
                            ? Colors.red
                            : _borderColor,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: selectedRhFactor,
                      hint: const Text('Rh'),
                      isExpanded: true,
                      underline: Container(),
                      items: _rhFactors.map((rh) {
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
                          color: Colors.red,
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