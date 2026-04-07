import 'package:flutter/material.dart';
import '../entities/medical_parameter.dart';

class ExamFormValidator {
  static bool isFormValid({
    required DateTime? selectedDate,
    required TimeOfDay? selectedTime,
    required List<MedicalParameter> parameters,
    required Map<int, dynamic> parameterValues,
  }) {
    if (selectedDate == null || selectedTime == null) return false;

    for (var param in parameters) {
      if (!parameterValues.containsKey(param.id)) return false;
      final value = parameterValues[param.id];
      if (value == null || value.toString().trim().isEmpty) return false;
    }

    return true;
  }

  static String? getDateError(DateTime? date, bool triedToSubmit) {
    return (triedToSubmit && date == null) ? 'Выберите дату' : null;
  }

  static String? getTimeError(TimeOfDay? time, bool triedToSubmit) {
    return (triedToSubmit && time == null) ? 'Выберите время' : null;
  }
}