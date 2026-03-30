import '../../../../core/network/api_client.dart';
import '../../../../models/mother.dart';

class MotherRepository {
  Future<Mother> createMother(Mother mother) async {

    try {
      final response = await ApiClient.postAuth('mothers', mother.toJson());

      if (response['success'] == true) {
        return Mother.fromJson(response['data']);
      } else {
        throw Exception(response['error'] ?? 'Ошибка создания матери');
      }
    } catch (e) {
      rethrow;
    }
  }
}