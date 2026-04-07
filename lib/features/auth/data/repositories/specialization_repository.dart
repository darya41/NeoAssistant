import '../../../../core/network/api_client.dart';
import '../../../../models/specialization.dart';

class SpecializationRepository {
  Future<List<Specialization>> getSpecializations() async {
    try {
      final data = await ApiClient.get('specializations');
      return (data)
          .map((json) => Specialization.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }
}