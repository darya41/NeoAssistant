import 'dart:convert';
import '../../../../models/patient.dart';
import '../services/patient_service.dart';

class PatientRepository {
  final PatientService _service = PatientService();

  Future<List<Patient>> getPatients() async {
    try {
      final response = await _service.getPatients();

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Patient.fromJson(json)).toList();
      } else {
        throw Exception('Ошибка загрузки пациентов: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка соединения: $e');
    }
  }

  Future<Patient> getPatientById(int patientId) async {
    try {
      final response = await _service.getPatientById(patientId);

      if (response.statusCode == 200) {
        return Patient.fromJson(json.decode(response.body));
      } else {
        throw Exception('Ошибка загрузки пациента: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка соединения: $e');
    }
  }

  Future<List<Patient>> searchPatients(String query) async {
    try {
      final response = await _service.searchPatients(query);

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(response.body);
        final List<dynamic> data = result['data'] ?? [];
        return data.map((json) => Patient.fromJson(json)).toList();
      } else {
        throw Exception('Ошибка поиска: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка соединения: $e');
    }
  }

  Future<Patient> createPatient(Map<String, dynamic> patientData) async {
    try {
      final response = await _service.createPatient(patientData);

      if (response.statusCode == 201) {
        return Patient.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Ошибка создания пациента');
      }
    } catch (e) {
      throw Exception('Ошибка соединения: $e');
    }
  }
}