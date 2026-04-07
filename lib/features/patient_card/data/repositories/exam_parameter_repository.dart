// data/repositories/exam_parameter_repository.dart
import 'dart:developer';
import '../../domain/entities/medical_parameter.dart';
import '../../domain/entities/medical_parameter_value.dart';
import '../services/exam_parameter_service.dart';

class ExamParameterRepository {
  final ExamParameterService _service = ExamParameterService();

  /// Валидация ответа API
  Map<String, dynamic> _validateResponse(Map<String, dynamic> response) {
    if (response['success'] != true) {
      throw Exception(response['error'] ?? 'Неизвестная ошибка');
    }
    return response;
  }

  /// Получение параметров по examId
  Future<List<MedicalParameter>> getParameters(int examId) async {
    try {
      final response = await _service.getParameters(examId);
      _validateResponse(response);

      final List<dynamic> data = response['data'] ?? [];
      return data.map((json) => MedicalParameter.fromJson(json)).toList();
    } catch (e) {
      log('Ошибка загрузки параметров', error: e, name: 'ExamParameterRepository');
      throw Exception('Ошибка загрузки параметров: $e');
    }
  }

  /// Получение параметров со значениями
  Future<List<MedicalParameterValue>> getParametersWithValues({
    required int examId,
    required int patientExamId,
  }) async {
    try {
      final response = await _service.getParametersWithValues(
        examId: examId,
        patientExamId: patientExamId,
      );

      _validateResponse(response);

      final List<dynamic> data = response['data'] ?? [];
      return data.map((json) => MedicalParameterValue(
        name: json['name'] ?? '',
        value: json['value'],
      )).toList();
    } catch (e) {
      log('Ошибка загрузки параметров со значениями', error: e, name: 'ExamParameterRepository');
      throw Exception('Ошибка загрузки параметров со значениями: $e');
    }
  }

  /// Получение параметров со значениями по ID осмотра
  Future<List<MedicalParameterValue>> getParametersWithValuesByExamId({
    required int patientExamId,
  }) async {
    try {
      final response = await _service.getParametersWithValuesByExamId(
        patientExamId: patientExamId,
      );

      _validateResponse(response);

      final List<dynamic> data = response['data'] ?? [];
      return data.map((json) => MedicalParameterValue(
        name: json['name'] ?? '',
        value: json['value'],
      )).toList();
    } catch (e) {
      log('Ошибка загрузки параметров по ID осмотра', error: e, name: 'ExamParameterRepository');
      throw Exception('Ошибка загрузки параметров по ID осмотра: $e');
    }
  }

  /// Сохранение параметров осмотра
  Future<void> saveExamParameters(
      int patientsExamsId,
      Map<int, dynamic> parameters,
      ) async {
    if (patientsExamsId <= 0) {
      throw Exception('Сохранение параметров: некорректный ID осмотра');
    }

    try {
      final List<Map<String, dynamic>> paramsList = [];

      for (var entry in parameters.entries) {
        final value = entry.value?.toString().trim() ?? '';
        if (value.isNotEmpty) {
          paramsList.add({
            'medical_parameter_id': entry.key,
            'value': value,
          });
        }
      }

      if (paramsList.isEmpty) {
        return;
      }

      final response = await _service.saveExamParameters(
        patientsExamsId,
        {'parameters': paramsList},
      );

      _validateResponse(response);
    } catch (e) {
      log('Ошибка сохранения параметров', error: e, name: 'ExamParameterRepository');
      throw Exception('Ошибка сохранения параметров: $e');
    }
  }
}