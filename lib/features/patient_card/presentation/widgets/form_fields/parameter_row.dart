import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/medical_parameter_value.dart';

class ParameterRow extends StatelessWidget {
  final MedicalParameterValue param;

  const ParameterRow({
    super.key,
    required this.param,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = param.value != null && param.value!.isNotEmpty;
    final displayValue = hasValue ? param.value! : '—';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 14,
            height: 1.4,
          ),
          children: [
            TextSpan(
              text: '${param.name}: ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            TextSpan(
              text: displayValue,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: hasValue ? Colors.black87 : AppColors.neutral_50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}