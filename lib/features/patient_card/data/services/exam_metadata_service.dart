import '../../../../core/network/api_client.dart';

class ExamMetadataService {
  Map<String, dynamic> _validateResponse(dynamic response, {String methodName = 'unknown'}) {

    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }

    if (response.containsKey('success') && response['success'] != true) {
      throw Exception(response['error'] ?? 'Ошибка сервера');
    }

    if (response.containsKey('data')) {
      final data = response['data'];

      if (data is Map<String, dynamic>) {
        return data;
      } else {
        return {'result': data};
      }
    }
    return response;
  }

  Future<Map<String, dynamic>> getPrimaryExamId({
    required int patientId,
    required int examTypeId,
  }) async {
    const methodName = 'getPrimaryExamId';

    try {
      final url = 'exam-types/primary?patientId=$patientId&examTypeId=$examTypeId';

      final response = await ApiClient.getAuth(url);

      final validated = _validateResponse(response, methodName: methodName);

      return validated;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getExamDateTime(int patientExamId) async {
    const methodName = 'getExamDateTime';

    try {
      final url = 'exam-types/datetime?patientExamId=$patientExamId';

      final response = await ApiClient.getAuth(url);

      final validated = _validateResponse(response, methodName: methodName);

      return validated;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getExamTypeByExamId(int patientExamId) async {
    const methodName = 'getExamTypeByExamId';

    try {
      final url = 'exam-types/type?patientExamId=$patientExamId';

      final response = await ApiClient.getAuth(url);

      final validated = _validateResponse(response, methodName: methodName);

      return validated;
    } catch (e) {
      rethrow;
    }
  }
}