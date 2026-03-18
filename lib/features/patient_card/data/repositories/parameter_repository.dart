import '../../../../core/network/api_client.dart';
import '../../../../models/medical_parameter.dart';

class ParameterRepository {
  Future<List<MedicalParameter>> getParameters(int examId) async {
    try {
      final response = await ApiClient.getAuth('parameters?examId=$examId');

      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];

        final parameters = data.map((json) {
          return MedicalParameter.fromJson(json);
        }).toList();

        return parameters;
      } else {
        throw Exception(response['error'] ?? 'Ошибка загрузки параметров');
      }
    } catch (e) {
      rethrow;
    }
  }
}