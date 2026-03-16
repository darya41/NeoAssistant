import '../../../../core/network/api_client.dart';
import '../../../../core/storage/token_storage.dart';

class ProfileRepository {
  Future<Map<String, dynamic>> updateProfile({
    required String lastName,
    required String firstName,
    String? patronymic,
    required String email,
    required String phone,
    required int specializationId,
    String? password,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'lastName': lastName,
        'firstName': firstName,
        'patronymic': patronymic,
        'email': email,
        'phone': phone,
        'specializationId': specializationId,
      };

      if (password != null && password.isNotEmpty) {
        data['password'] = password;
      }

      final response = await ApiClient.putAuth('doctors/profile', data);

      if (response['success'] == true) {
        final currentData = await TokenStorage.getDoctorData() ?? {};
        final updatedData = {
          ...currentData,
          'firstName': firstName,
          'lastName': lastName,
          'patronymic': patronymic,
          'email': email,
          'phone': phone,
          'specialization': response['doctor']['specialization'],
        };

        await TokenStorage.saveDoctorData(updatedData);

        return response;
      } else {
        throw Exception(response['error'] ?? 'Ошибка обновления профиля');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await ApiClient.getAuth('doctors/profile');

      if (response['success'] == true) {
        return response['doctor'];
      } else {
        throw Exception(response['error'] ?? 'Ошибка загрузки профиля');
      }
    } catch (e) {
      rethrow;
    }
  }
}