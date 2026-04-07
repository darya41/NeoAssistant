import '../../../../core/network/api_client.dart';

class PatientExamService {

  Map<String, dynamic> _validateResponse(dynamic response) {
    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }
    return response;
  }

  Future<Map<String, dynamic>> createPatientExam(Map<String, dynamic> examData) async {
    final response = await ApiClient.postAuth('patient-exams', examData);
    return _validateResponse(response);
  }

  Future<Map<String, dynamic>> getPatientExamsByType({
    required int patientId,
    required int examTypeId,
  }) async {
    final response = await ApiClient.getAuth(
        'patient-exams?patientId=$patientId&examTypeId=$examTypeId'
    );
    return _validateResponse(response);
  }
}