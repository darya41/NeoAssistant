import 'package:flutter/material.dart';
import '../../../../../models/medical_parameter_value.dart';
import 'parameter_row.dart';

class ParametersList extends StatelessWidget {
  final List<MedicalParameterValue> parameters;

  const ParametersList({
    super.key,
    required this.parameters,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Первичный осмотр новорожденного',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            ...parameters.map((param) => ParameterRow(param: param)),
          ],
        ),
      ),
    );
  }
}