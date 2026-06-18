import '../../../../core/network/api_client.dart';

class ExamParameterService {
  Map<String, dynamic> _validateResponse(dynamic response) {
    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }
    return response;
  }

  Future<Map<String, dynamic>> getParameters(int examId) async {
    final response = await ApiClient.getAuth('parameters?examId=$examId');
    return _validateResponse(response);
  }

  Future<Map<String, dynamic>> getParametersWithValues({
    required int examId,
    required int patientExamId,
  }) async {
    final response = await ApiClient.getAuth(
        'parameters/with-values?examId=$examId&patientExamId=$patientExamId'
    );
    return _validateResponse(response);
  }

  Future<Map<String, dynamic>> getParametersWithValuesByExamId({
    required int patientExamId,
  }) async {
    final response = await ApiClient.getAuth(
        'parameters/values-by-exam-id?patientExamId=$patientExamId'
    );
    return _validateResponse(response);
  }

  Future<Map<String, dynamic>> saveExamParameters(
      int patientsExamsId,
      Map<String, dynamic> requestData,
      ) async {
    final response = await ApiClient.postAuth(
      'patient-exams/$patientsExamsId/parameters',
      requestData,
    );
    return _validateResponse(response);
  }
}