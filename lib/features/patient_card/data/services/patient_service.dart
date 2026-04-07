import '../../../../core/network/api_client.dart';

class PatientService {
  Future<Map<String, dynamic>> createPatient(Map<String, dynamic> patientData) async {
    final response = await ApiClient.postAuth('patients', patientData);

    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }

    return response;
  }
}