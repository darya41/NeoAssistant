import 'package:flutter/material.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/network/api_client.dart';

class SettingsViewModel extends ChangeNotifier {
  bool _isLoggingOut = false;
  String? _errorMessage;
  String _appVersion = '1.03.02';

  bool get isLoggingOut => _isLoggingOut;
  String? get errorMessage => _errorMessage;
  String get appVersion => _appVersion;

  SettingsViewModel() {
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    _appVersion = '1.03.02';
    notifyListeners();
  }

  Future<bool> showLogoutConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выход из аккаунта'),
        content: const Text('Вы уверены, что хотите выйти из аккаунта?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Выйти',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<bool> logout(BuildContext context) async {
    _isLoggingOut = true;
    _errorMessage = null;
    notifyListeners();

    try {
     try {
        final refreshToken = await TokenStorage.getRefreshToken();
        if (refreshToken != null) {
          await ApiClient.post('auth/logout', {
            'refreshToken': refreshToken,
          });
        }
      } catch (e) {
        print('Logout API error: $e');
      }

      await TokenStorage.clearAll();

      _isLoggingOut = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = 'Ошибка при выходе: $e';
      _isLoggingOut = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}