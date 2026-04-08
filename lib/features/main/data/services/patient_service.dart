import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/storage/token_storage.dart';

class PatientService {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  Future<http.Response> getPatients() async {
    final token = await TokenStorage.getAccessToken();

    return await http.get(
      Uri.parse('$baseUrl/patients'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> getPatientById(int patientId) async {
    final token = await TokenStorage.getAccessToken();

    return await http.get(
      Uri.parse('$baseUrl/patients/$patientId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> searchPatients(String query) async {
    final token = await TokenStorage.getAccessToken();

    return await http.get(
      Uri.parse('$baseUrl/patients/search?query=$query'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> createPatient(Map<String, dynamic> patientData) async {
    final token = await TokenStorage.getAccessToken();

    return await http.post(
      Uri.parse('$baseUrl/patients'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(patientData),
    );
  }
}