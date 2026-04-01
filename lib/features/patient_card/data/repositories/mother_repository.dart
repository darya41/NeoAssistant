import '../../../../core/network/api_client.dart';
import '../../../../models/mother.dart';

class MotherRepository {
  Future<Mother> createMother(Mother mother) async {
    try {
      final motherData = mother.toJson();

      final response = await ApiClient.postAuth('mothers', motherData);

      if (response is! Map<String, dynamic>) {
        throw Exception('Неверный формат ответа');
      }

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка создания матери');
      }

      final motherDataResponse = response['data'];

      if (motherDataResponse == null) {
        throw Exception('Сервер не вернул данные матери');
      }

      final Map<String, dynamic> motherJson;
      if (motherDataResponse is List) {
        if (motherDataResponse.isEmpty) {
          throw Exception('Сервер вернул пустой список');
        }
        motherJson = motherDataResponse[0];
      } else if (motherDataResponse is Map<String, dynamic>) {
        motherJson = motherDataResponse;
      } else {
        throw Exception('Неверный тип данных: ${motherDataResponse.runtimeType}');
      }

      if (!motherJson.containsKey('mother_id') && !motherJson.containsKey('id')) {
        throw Exception('Сервер не вернул ID матери');
      }

      final createdMother = Mother.fromJson(motherJson);

      return createdMother;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Mother>> getAllMothers() async {
    try {

      final response = await ApiClient.getAuth('mothers');

      if (response is! Map<String, dynamic>) {
        return [];
      }

      if (response['success'] != true) {
        return [];
      }

      final mothersData = response['data'];

      if (mothersData == null) {
        return [];
      }

      List<Mother> mothers = [];

      if (mothersData is List) {
        for (var item in mothersData) {
          if (item is Map<String, dynamic>) {
            final mother = Mother.fromJson(item);
            mothers.add(mother);
          }
        }
      } else if (mothersData is Map<String, dynamic>) {
        final mother = Mother.fromJson(mothersData);
        mothers.add(mother);
      }

      return mothers;
    } catch (e) {
      return [];
    }
  }

  Future<Mother> getMotherById(int id) async {
    try {
      print('📤 MotherRepository.getMotherById: $id');

      final response = await ApiClient.getAuth('mothers/$id');

      print('📥 Ответ сервера: $response');
      print('📥 Тип ответа: ${response.runtimeType}');

      // Проверяем, что ответ - это Map
      if (response is! Map<String, dynamic>) {
        print('❌ Ответ не является Map');
        throw Exception('Неверный формат ответа');
      }

      // Проверяем success
      if (response['success'] != true) {
        print('❌ Сервер вернул ошибку: ${response['error']}');
        throw Exception(response['error'] ?? 'Ошибка загрузки матери');
      }

      // Получаем данные матери
      final motherData = response['data'];
      print('📦 motherData: $motherData');

      if (motherData == null) {
        print('❌ motherData = null');
        throw Exception('Мать не найдена');
      }

      // Если motherData - это список, берем первый элемент
      final Map<String, dynamic> motherJson;
      if (motherData is List) {
        if (motherData.isEmpty) {
          throw Exception('Сервер вернул пустой список');
        }
        motherJson = motherData[0];
      } else if (motherData is Map<String, dynamic>) {
        motherJson = motherData;
      } else {
        throw Exception('Неверный тип данных: ${motherData.runtimeType}');
      }

      print('📦 motherJson: $motherJson');

      final mother = Mother.fromJson(motherJson);
      print('✅ Мать загружена: ID=${mother.id}, ФИО=${mother.fullName}');

      return mother;
    } catch (e) {
      print('❌ Ошибка в MotherRepository.getMotherById: $e');
      rethrow;
    }
  }
}