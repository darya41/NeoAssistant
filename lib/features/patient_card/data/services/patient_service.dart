import '../../../../core/network/api_client.dart';

class PatientService {
  Map<String, dynamic> _validateResponse(dynamic response) {
    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }
    return response;
  }

  Future<Map<String, dynamic>> createPatient(Map<String, dynamic> patientData) async {
    final response = await ApiClient.postAuth('patients', patientData);
    return _validateResponse(response);
  }
}