import '../../../../core/network/api_client.dart';
import '../../domain/entities/mother.dart';

class MotherService {

  Future<Map<String, dynamic>> createMother(Mother mother) async {
    final response = await ApiClient.postAuth('mothers', mother.toJson());

    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }

    return response;
  }

  Future<Map<String, dynamic>> getAllMothers() async {
    final response = await ApiClient.getAuth('mothers');

    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }

    return response;
  }

  Future<Map<String, dynamic>> getMotherById(int id) async {
    final response = await ApiClient.getAuth('mothers/$id');

    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }

    return response;
  }

  Future<Map<String, dynamic>> updateMother(int id, Mother mother) async {
    final response = await ApiClient.putAuth('mothers/$id', mother.toJson());

    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }

    return response;
  }

  Future<void> deleteMother(int id) async {
    final response = await ApiClient.deleteAuth('mothers/$id');

    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }
  }
}