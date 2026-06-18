import '../../../../core/storage/token_storage.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String lastName,
    required String firstName,
    String? middleName,
    required String phone,
    required int positionId,
  }) async {
    try {
      final response = await _authService.register(
        email: email,
        password: password,
        lastName: lastName,
        firstName: firstName,
        middleName: middleName,
        phone: phone,
        specializationId: positionId,
      );

      if (response['success'] == true) {
        return response;
      } else {
        throw Exception(response['error'] ?? 'Ошибка регистрации');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      if (response['success'] == true) {
        await TokenStorage.saveTokens(
          accessToken: response['accessToken'],
          refreshToken: response['refreshToken'],
          doctorData: response['doctor'],
        );
        return response;
      } else {
        throw Exception(response['error'] ?? 'Ошибка входа');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> refreshToken() async {
    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken == null) {
        return false;
      }

      final response = await _authService.refreshToken(
        refreshToken: refreshToken,
      );

      if (response['success'] == true) {
        await TokenStorage.saveAccessToken(response['accessToken']);

        if (response['refreshToken'] != null) {
          final doctorData = await TokenStorage.getDoctorData();
          await TokenStorage.saveTokens(
            accessToken: response['accessToken'],
            refreshToken: response['refreshToken'],
            doctorData: doctorData ?? {},
          );
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken != null) {
        await _authService.logout(refreshToken);
      }
    } finally {
      await TokenStorage.clearAll();
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await TokenStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }
}