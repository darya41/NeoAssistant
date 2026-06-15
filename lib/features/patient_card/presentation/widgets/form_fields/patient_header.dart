import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class PatientHeader extends StatelessWidget {
  final String numberHistory;
  final String motherName;

  const PatientHeader({
    super.key,
    required this.numberHistory,
    required this.motherName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          numberHistory,
          style: const TextStyle(
            fontSize: 18,
            color: AppColors.neutral_50,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          motherName,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}