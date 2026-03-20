import 'package:flutter/material.dart';

class CheckboxGroupWidget extends StatelessWidget {
  final bool gestationalDiabetes;
  final bool preeclampsia;
  final Function(bool, bool) onChanged;

  static const _activeColor = Color(0xFF44E4BF);

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
              activeColor: _activeColor,
              onChanged: (value) => onChanged(value ?? false, preeclampsia),
            ),
            const Text('Гестационный диабет'),
          ],
        ),
        Row(
          children: [
            Checkbox(
              value: preeclampsia,
              activeColor: _activeColor,
              onChanged: (value) => onChanged(gestationalDiabetes, value ?? false),
            ),
            const Text('Преэклампсия'),
          ],
        ),
      ],
    );
  }
}