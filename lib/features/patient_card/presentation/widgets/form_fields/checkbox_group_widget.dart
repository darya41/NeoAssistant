import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class CheckboxGroupWidget extends StatelessWidget {
  final bool gestationalDiabetes;
  final bool preeclampsia;
  final Function(bool, bool) onChanged;

  const CheckboxGroupWidget({
    super.key,
    required this.gestationalDiabetes,
    required this.preeclampsia,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              value: gestationalDiabetes,
              activeColor: AppColors.brand_40,
              onChanged: (value) => onChanged(value ?? false, preeclampsia),
            ),
            const Text('Гестационный диабет'),
          ],
        ),
        Row(
          children: [
            Checkbox(
              value: preeclampsia,
              activeColor: AppColors.brand_40,
              onChanged: (value) => onChanged(gestationalDiabetes, value ?? false),
            ),
            const Text('Преэклампсия'),
          ],
        ),
      ],
    );
  }
}