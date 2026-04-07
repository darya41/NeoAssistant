import 'dart:developer';
import '../services/patient_exam_service.dart';

class PatientExamRepository {
  final PatientExamService _service = PatientExamService();
  static const String _defaultErrorMessage = 'Неизвестная ошибка';

  Map<String, dynamic> _handleResponse(dynamic response, String context) {
    if (response is! Map<String, dynamic>) {
      throw Exception('$context: Неверный формат ответа от сервера');
    }

    if (response['success'] != true) {
      throw Exception(response['error'] ?? '$_defaultErrorMessage при $context');
    }

    return response;
  }

  Future<int> createPatientExam(Map<String, dynamic> examData) async {
    try {
      final response = await _service.createPatientExam(examData);
      _handleResponse(response, 'создании осмотра');

      final examId = response['data']?['patients_exams_id'];
      if (examId == null) {
        throw Exception('Создание осмотра: ID не получен от сервера');
      }

      log('Осмотр создан с ID: $examId', name: 'PatientExamRepository');
      return examId as int;
    } catch (e) {
      log('Ошибка создания осмотра', error: e, name: 'PatientExamRepository');
      throw Exception('Ошибка создания осмотра: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getPatientExamsByType({
    required int patientId,
    required int examTypeId,
  }) async {
    if (patientId <= 0) {
      throw Exception('Загрузка осмотров: некорректный ID пациента');
    }

    if (examTypeId <= 0) {
      throw Exception('Загрузка осмотров: некорректный ID типа осмотра');
    }

    try {
      final response = await _service.getPatientExamsByType(
        patientId: patientId,
        examTypeId: examTypeId,
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка загрузки осмотров');
      }

      final List<dynamic> data = response['data'] ?? [];
      final exams = data.map((item) => Map<String, dynamic>.from(item)).toList();

      log('Загружено ${exams.length} осмотров для пациента $patientId',
          name: 'PatientExamRepository');

      return exams;
    } catch (e) {
      log('Ошибка загрузки осмотров', error: e, name: 'PatientExamRepository');
      throw Exception('Ошибка загрузки осмотров: $e');
    }
  }
}