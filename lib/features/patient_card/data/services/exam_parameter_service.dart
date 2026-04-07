import '../../../../core/network/api_client.dart';

class ExamParameterService {
  /// Получение параметров по examId
  Future<Map<String, dynamic>> getParameters(int examId) async {
    final response = await ApiClient.getAuth('parameters?examId=$examId');

    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }

    return response;
  }

  Future<Map<String, dynamic>> getParametersWithValues({
    required int examId,
    required int patientExamId,
  }) async {
    final response = await ApiClient.getAuth(
        'parameters/with-values?examId=$examId&patientExamId=$patientExamId'
    );

    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }

    return response;
  }

  /// Получение параметров со значениями по ID осмотра
  Future<Map<String, dynamic>> getParametersWithValuesByExamId({
    required int patientExamId,
  }) async {
    final response = await ApiClient.getAuth(
        'parameters/values-by-exam-id?patientExamId=$patientExamId'
    );

    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }

    return response;
  }

  // Сохранение параметров
  Future<Map<String, dynamic>> saveExamParameters(
      int patientsExamsId,
      Map<String, dynamic> requestData,
      ) async {
    final response = await ApiClient.postAuth(
      'patient-exams/$patientsExamsId/parameters',
      requestData,
    );

    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }

    return response;
  }
}