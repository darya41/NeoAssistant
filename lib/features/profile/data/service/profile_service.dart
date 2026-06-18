import '../../../../core/network/api_client.dart';

class ProfileService {
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    return await ApiClient.putAuth('doctors/profile', data);
  }

  Future<Map<String, dynamic>> getProfile() async {
    return await ApiClient.getAuth('doctors/profile');
  }
}