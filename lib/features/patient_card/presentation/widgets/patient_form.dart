import 'package:flutter/material.dart';
import '../../../../models/mother.dart';
import 'form_fields/blood_type_selector.dart';
import 'form_fields/date_field.dart';
import 'form_fields/gender_selector.dart';
import 'form_fields/mother_search_field.dart';
import 'form_fields/text_input_field.dart';
import 'form_fields/time_field.dart';

class PatientFormWidget extends StatelessWidget {

  final TextEditingController motherFioController;
  final TextEditingController historyNumberController;
  final TextEditingController heightController;
  final TextEditingController weightController;

  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final String selectedGender;
  final String? selectedBloodGroup;
  final String? selectedRhFactor;

  final VoidCallback onMotherSearchChanged;
  final Function(Mother) onMotherSelected;
  final Function(DateTime) onDateSelected;
  final Function(TimeOfDay) onTimeSelected;
  final Function(String) onGenderSelected;
  final Function(String?) onBloodGroupChanged;
  final Function(String?) onRhFactorChanged;

  final bool showValidationErrors;
  final String? motherFioError;
  final String? historyNumberError;
  final String? heightError;
  final String? weightError;
  final String? dateError;
  final String? timeError;
  final String? genderError;
  final String? bloodGroupError;
  final String? rhFactorError;

  const PatientFormWidget({
    super.key,
    required this.motherFioController,
    required this.historyNumberController,
    required this.heightController,
    required this.weightController,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedGender,
    this.selectedBloodGroup,
    this.selectedRhFactor,
    required this.onMotherSearchChanged,
    required this.onMotherSelected,
    required this.onDateSelected,
    required this.onTimeSelected,
    required this.onGenderSelected,
    required this.onBloodGroupChanged,
    required this.onRhFactorChanged,
    this.showValidationErrors = false,
    this.motherFioError,
    this.historyNumberError,
    this.heightError,
    this.weightError,
    this.dateError,
    this.timeError,
    this.genderError,
    this.bloodGroupError,
    this.rhFactorError,
  });

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      onTimeSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MotherSearchField(
          controller: motherFioController,
          onMotherSelected: onMotherSelected,
          errorText: motherFioError,
        ),
        const SizedBox(height: 16),

        TextInputField(
          controller: historyNumberController,
          hintText: 'Номер истории',
          keyboardType: TextInputType.number,
          errorText: historyNumberError,
          showError: showValidationErrors && historyNumberError != null,
        ),
        const SizedBox(height: 12),

        DateField(
          selectedDate: selectedDate,
          onTap: () => _selectDate(context),
          errorText: dateError,
          showError: showValidationErrors && dateError != null,
        ),
        const SizedBox(height: 12),

        TimeField(
          timeDisplay: selectedTime != null
              ? selectedTime!.format(context)
              : '',
          onTap: () => _selectTime(context),
          hintText: 'Выберите время',
        ),
        const SizedBox(height: 12),

        TextInputField(
          controller: heightController,
          hintText: 'Рост ребёнка (сантиметров)',
          keyboardType: TextInputType.number,
          errorText: heightError,
          showError: showValidationErrors && heightError != null,
        ),
        const SizedBox(height: 12),

        TextInputField(
          controller: weightController,
          hintText: 'Вес ребёнка (грамм)',
          keyboardType: TextInputType.number,
          errorText: weightError,
          showError: showValidationErrors && weightError != null,
        ),
        const SizedBox(height: 12),

        GenderSelector(
          selectedGender: selectedGender,
          onGenderSelected: onGenderSelected,
        ),

        BloodTypeSelector(
          selectedBloodGroup: selectedBloodGroup,
          selectedRhFactor: selectedRhFactor,
          onBloodGroupChanged: onBloodGroupChanged,
          onRhFactorChanged: onRhFactorChanged,
          showValidationErrors: showValidationErrors,
          bloodGroupError: bloodGroupError,
          rhFactorError: rhFactorError,
        ),
      ],
    );
  }
}