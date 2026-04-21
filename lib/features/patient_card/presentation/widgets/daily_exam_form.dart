import 'package:flutter/material.dart';
import '../../domain/entities/medical_parameter.dart';
import 'form_fields/parameter_field.dart';

class DailyExamForm extends StatelessWidget {
  final List<MedicalParameter> parameters;
  final Map<int, dynamic> parameterValues;
  final Function(int, dynamic) onParameterChanged;

  const DailyExamForm({
    super.key,
    required this.parameters,
    required this.parameterValues,
    required this.onParameterChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (parameters.isEmpty) {
      return const Center(
        child: Text('Нет параметров для отображения'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Параметры осмотра',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...parameters.map((param) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ParameterField(
            param: param,
            value: parameterValues[param.id],
            onChanged: (value) => onParameterChanged(param.id, value),
          ),
        )),
      ],
    );
  }
}