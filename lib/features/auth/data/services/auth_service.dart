import '../../../../core/network/api_client.dart';

class AuthService {

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String lastName,
    required String firstName,
    String? middleName,
    required String phone,
    required int specializationId,
  }) async {
    return await ApiClient.post('auth/register', {
      'email': email,
      'password': password,
      'last_name': lastName,
      'first_name': firstName,
      'middle_name': middleName,
      'personal_phone': phone,
      'specialization_id': specializationId,
    });
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return await ApiClient.post('auth/login', {
      'email': email,
      'password': password,
    });
  }

  Future<Map<String, dynamic>> refreshToken({
    required String refreshToken,
  }) async {
    return await ApiClient.post('auth/refresh', {
      'refreshToken': refreshToken,
    });
  }

  Future<void> logout(String refreshToken) async {
    await ApiClient.post('auth/logout', {
      'refreshToken': refreshToken,
    });
  }
}