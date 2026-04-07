import '../../../../core/network/api_client.dart';

class ExamMetadataService {
  Map<String, dynamic> _validateResponse(dynamic response) {
    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }
    return response;
  }

  Future<Map<String, dynamic>> getPrimaryExamId({
    required int patientId,
    required int examTypeId,
  }) async {
    final response = await ApiClient.getAuth(
        'parameters/primary-exam?patientId=$patientId&examTypeId=$examTypeId'
    );
    return _validateResponse(response);
  }

  Future<Map<String, dynamic>> getExamDateTime(int patientExamId) async {
    final response = await ApiClient.getAuth(
        'parameters/exam-datetime?patientExamId=$patientExamId'
    );
    return _validateResponse(response);
  }

  Future<Map<String, dynamic>> getExamTypeByExamId(int patientExamId) async {
    final response = await ApiClient.getAuth(
        'parameters/exam-type?patientExamId=$patientExamId'
    );
    return _validateResponse(response);
  }
}