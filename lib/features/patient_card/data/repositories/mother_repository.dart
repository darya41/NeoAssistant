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
}