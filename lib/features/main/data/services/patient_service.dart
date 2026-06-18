import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/storage/token_storage.dart';

class PatientService {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  Future<http.Response> getPatients({int page = 1, int limit = 15}) async {
    final token = await TokenStorage.getAccessToken();

    return await http.get(
      Uri.parse('$baseUrl/patients?page=$page&limit=$limit'),
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

  Future<http.Response> searchPatients({
    required String query,
    int page = 1,
    int limit = 15,
    String? gender,
    String? bloodGroup,
    String? rhFactor,
    String? dateFrom,
    String? dateTo,
  }) async {
    final token = await TokenStorage.getAccessToken();

    final uri = Uri.parse('$baseUrl/patients/search').replace(queryParameters: {
      'query': query,
      'page': page.toString(),
      'limit': limit.toString(),
      if (gender != null && gender.isNotEmpty) 'gender': gender,
      if (bloodGroup != null && bloodGroup.isNotEmpty) 'bloodGroup': bloodGroup,
      if (rhFactor != null && rhFactor.isNotEmpty) 'rhFactor': rhFactor,
      if (dateFrom != null && dateFrom.isNotEmpty) 'dateFrom': dateFrom,
      if (dateTo != null && dateTo.isNotEmpty) 'dateTo': dateTo,
    });

    return await http.get(
      uri,
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