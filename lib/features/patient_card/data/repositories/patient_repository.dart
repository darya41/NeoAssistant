// data/repositories/
import 'dart:developer';
import '../services/patient_service.dart';

class PatientRepository {
  final PatientService _service = PatientService();
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

  /// Создание пациента
  Future<int> createPatient(Map<String, dynamic> patientData) async {
    try {
      final response = await _service.createPatient(patientData);
      _handleResponse(response, 'создании пациента');

      final patientId = response['data']?['patient_id'];
      if (patientId == null) {
        throw Exception('Создание пациента: ID не получен от сервера');
      }

      log('Пациент создан с ID: $patientId', name: 'PatientRepository');
      return patientId as int;
    } catch (e) {
      log('Ошибка создания пациента', error: e, name: 'PatientRepository');
      throw Exception('Ошибка создания пациента: $e');
    }
  }
}