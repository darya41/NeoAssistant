import '../../../../core/network/api_client.dart';

class ExamMetadataService {
  /// Получение ID первичного осмотра
  Future<Map<String, dynamic>> getPrimaryExamId({
    required int patientId,
    required int examTypeId,
  }) async {
    final response = await ApiClient.getAuth(
        'parameters/primary-exam?patientId=$patientId&examTypeId=$examTypeId'
    );

    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }

    return response;
  }

  /// Получение даты и времени осмотра
  Future<Map<String, dynamic>> getExamDateTime(int patientExamId) async {
    final response = await ApiClient.getAuth(
        'parameters/exam-datetime?patientExamId=$patientExamId'
    );

    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }

    return response;
  }

  /// Получение типа осмотра по ID
  Future<Map<String, dynamic>> getExamTypeByExamId(int patientExamId) async {
    final response = await ApiClient.getAuth(
        'parameters/exam-type?patientExamId=$patientExamId'
    );

    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }

    return response;
  }
}