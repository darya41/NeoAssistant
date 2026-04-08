import '../../../../core/network/api_client.dart';

class SpecializationService {
  Future<List<dynamic>> getSpecializations() async {
    return await ApiClient.get('specializations');
  }
}