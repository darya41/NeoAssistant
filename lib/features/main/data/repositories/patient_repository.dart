import 'dart:convert';
import '../../../patient_card/domain/entities/patient.dart';
import '../services/patient_service.dart';

class PatientRepository {
  final PatientService _service = PatientService();

  Future<Map<String, dynamic>> getPatients({int page = 1, int limit = 15}) async {
    try {
      final response = await _service.getPatients(page: page, limit: limit);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];
        final pagination = responseData['pagination'];

        return {
          'patients': data.map((json) => Patient.fromJson(json)).toList(),
          'hasNext': pagination['hasNext'] ?? false,
          'currentPage': pagination['currentPage'] ?? page,
          'total': pagination['total'] ?? 0,
        };
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

  Future<Map<String, dynamic>> searchPatients({
    required String query,
    int page = 1,
    int limit = 15,
    String? gender,
    String? bloodGroup,
    String? rhFactor,
    String? dateFrom,
    String? dateTo,
  }) async {
    try {
      final response = await _service.searchPatients(
        query: query,
        page: page,
        limit: limit,
        gender: gender,
        bloodGroup: bloodGroup,
        rhFactor: rhFactor,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];
        final pagination = responseData['pagination'] ?? {};

        return {
          'patients': data.map((json) => Patient.fromJson(json)).toList(),
          'hasNext': pagination['hasNext'] ?? false,
          'currentPage': pagination['currentPage'] ?? page,
          'total': pagination['total'] ?? 0,
        };
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