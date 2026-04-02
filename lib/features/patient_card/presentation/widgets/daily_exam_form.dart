import 'package:flutter/material.dart';
import '../../domain/entities/medical_parameter.dart';
import 'form_fields/date_field.dart';
import 'form_fields/parameter_field.dart';
import 'form_fields/time_field.dart';

class DailyExamForm extends StatelessWidget {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final List<MedicalParameter> parameters;
  final Map<int, dynamic> parameterValues;
  final Function(int, dynamic) onParameterChanged;
  final bool showValidationErrors;
  final String? dateError;
  final String? timeError;

  const DailyExamForm({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.parameters,
    required this.parameterValues,
    required this.onParameterChanged,
    this.showValidationErrors = false,
    this.dateError,
    this.timeError,
  });

  Future<void> _selectDate(BuildContext context) async {
    await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Дата и время осмотра',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DateField(
                selectedDate: selectedDate,
                onTap: () => _selectDate(context),
                hintText: 'Выберите дату',
                errorText: dateError,
                showError: showValidationErrors && dateError != null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TimeField(
                timeDisplay: selectedTime != null
                    ? selectedTime!.format(context)
                    : '',
                onTap: () => _selectTime(context),
                hintText: 'Выберите время',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        const Text(
          'Параметры осмотра',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...parameters.map((param) => ParameterField(
          param: param,
          value: parameterValues[param.id],
          onChanged: (value) => onParameterChanged(param.id, value),
        )),
      ],
    );
  }
}