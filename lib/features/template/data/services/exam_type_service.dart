import '../../../../core/network/api_client.dart';

class ExamTypeService {
  Future<Map<String, dynamic>> getAllExamTypes() async {
    final response = await ApiClient.getAuth('exam-types/all-types'); // Исправлено

    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }

    return response;
  }

}