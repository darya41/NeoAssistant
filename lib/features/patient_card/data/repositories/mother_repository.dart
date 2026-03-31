import '../../../../core/network/api_client.dart';
import '../../../../models/mother.dart';

class MotherRepository {
  Future<Mother> createMother(Mother mother) async {
    try {

      final response = await ApiClient.postAuth('mothers', mother.toJson());

      if (response is! Map<String, dynamic>) {
        throw Exception('Неверный формат ответа');
      }

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка создания матери');
      }

      final motherData = response['data'];
      if (motherData == null) {
        throw Exception('Сервер не вернул данные матери');
      }

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
      }

      else if (mothersData is Map<String, dynamic>) {
        final mother = Mother.fromJson(mothersData);
        mothers.add(mother);
      }

      return mothers;

    } catch (e) {
      return [];
    }
  }
}