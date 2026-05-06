import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/validators/auth_validator.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get isFormValid {
    return emailController.text.trim().isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  LoginViewModel() {
    emailController.addListener(_onFormChanged);
    passwordController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    _errorMessage = null;
    notifyListeners();

    if (!isFormValid) {
      _errorMessage = 'Заполните оба поля';
      notifyListeners();
      return false;
    }

    if (!AuthValidator.isEmailValid(email)) {
      _errorMessage = 'Некорректная почта';
      notifyListeners();
      return false;
    }

    if (!AuthValidator.isPasswordValid(password)) {
      _errorMessage = 'Некорректный пароль';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authRepository.login(
        email: email,
        password: password,
      );

      if (response['success'] && response['accessToken'] != null) {
        return true;
      } else {
        _errorMessage = 'Неверный email или пароль';
        notifyListeners();
        return false;
      }
    } catch (e) {
      String errorMsg = e.toString();
      errorMsg = errorMsg.replaceFirst('Ошибка соединения: Exception: ', '');
      if (errorMsg.contains('Неверный email') || errorMsg.contains('пароль')) {
        _errorMessage = 'Неверный email или пароль';
      } else {
        _errorMessage = errorMsg;
      }
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.removeListener(_onFormChanged);
    passwordController.removeListener(_onFormChanged);
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}