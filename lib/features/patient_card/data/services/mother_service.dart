import '../../../../core/network/api_client.dart';
import '../../../../models/mother.dart';

class MotherService {

  /// Создание матери - только API вызов
  Future<Map<String, dynamic>> createMother(Mother mother) async {
    final response = await ApiClient.postAuth('mothers', mother.toJson());

    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }

    return response;
  }

  /// Получение всех матерей
  Future<Map<String, dynamic>> getAllMothers() async {
    final response = await ApiClient.getAuth('mothers');

    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }

    return response;
  }

  /// Получение матери по ID
  Future<Map<String, dynamic>> getMotherById(int id) async {
    final response = await ApiClient.getAuth('mothers/$id');

    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }

    return response;
  }

  /// Обновление матери
  Future<Map<String, dynamic>> updateMother(int id, Mother mother) async {
    final response = await ApiClient.putAuth('mothers/$id', mother.toJson());

    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }

    return response;
  }

  /// Удаление матери
  Future<void> deleteMother(int id) async {
    final response = await ApiClient.deleteAuth('mothers/$id');

    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }
  }
}