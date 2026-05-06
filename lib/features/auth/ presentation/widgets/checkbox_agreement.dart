import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class CheckboxAgreement extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String text;

  const CheckboxAgreement({
    super.key,
    required this.value,
    required this.onChanged,
    this.text = 'Согласие на обработку персональных данных',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.brand_40 ,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              maxLines: 2,
            ),
          ),
        ),
      ],
    );
  }
}