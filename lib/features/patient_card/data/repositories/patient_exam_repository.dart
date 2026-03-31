import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/storage/token_storage.dart';

class PatientExamRepository {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  static Future<int> createPatient(Map<String, dynamic> patientData) async {
    try {
      final token = await TokenStorage.getAccessToken();

      final response = await http.post(
        Uri.parse('$baseUrl/patients'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(patientData),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['data']['patient_id'];
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Ошибка создания пациента');
      }
    } catch (e) {
      throw Exception('Ошибка соединения: $e');
    }
  }

  static Future<int> createPatientExam(Map<String, dynamic> examData) async {
    try {
      final token = await TokenStorage.getAccessToken();

      final response = await http.post(
        Uri.parse('$baseUrl/patient-exams'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(examData),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['data']['patients_exams_id'];
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Ошибка создания осмотра');
      }
    } catch (e) {
      throw Exception('Ошибка соединения: $e');
    }
  }

  static Future<void> saveExamParameters(
      int patientsExamsId,
      Map<int, dynamic> parameters,
      ) async {
    try {
      final token = await TokenStorage.getAccessToken();

      final List<Map<String, dynamic>> paramsList = [];

      for (var entry in parameters.entries) {
        paramsList.add({
          'medical_parameter_id': entry.key,
          'value': entry.value.toString(),
        });
      }

      final response = await http.post(
        Uri.parse('$baseUrl/patient-exams/$patientsExamsId/parameters'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'parameters': paramsList}),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Ошибка сохранения параметров');
      }
    } catch (e) {
      throw Exception('Ошибка соединения: $e');
    }
  }
}