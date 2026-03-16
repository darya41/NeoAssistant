import '../../../../core/network/api_client.dart';

class AuthRepository {
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String lastName,
    required String firstName,
    String? middleName,
    required String phone,
    required int positionId,
  }) async {
    final fullName = [lastName, firstName, middleName]
        .where((name) => name != null && name.isNotEmpty)
        .join(' ');

    return await ApiClient.post('auth/register', {
      'email': email,
      'password': password,
      'full_name': fullName,
      'last_name': lastName,
      'first_name': firstName,
      'middle_name': middleName,
      'personal_phone': phone,
      'specialization_id': positionId,
    });
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return await ApiClient.login('auth/login', {
      'email': email,
      'password': password,
    });
  }
}