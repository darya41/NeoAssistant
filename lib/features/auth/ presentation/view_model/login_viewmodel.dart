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
    notifyListeners();
  }

  String? get emailError {
    final email = emailController.text.trim();
    if (email.isEmpty) return null;
    return AuthValidator.getEmailError(email);
  }

  String? get passwordError {
    final password = passwordController.text;
    if (password.isEmpty) return null;
    return AuthValidator.getPasswordError(password);
  }

  Future<bool> login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (!isFormValid) {
      _errorMessage = 'Заполните оба поля';
      notifyListeners();
      return false;
    }

    final validationError = AuthValidator.getLoginError(email, password);
    if (validationError != null) {
      _errorMessage = validationError;
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authRepository.login(
        email: email,
        password: password,
      );

      if (response['success'] && response['accessToken'] != null) {
        return true;
      } else {
        _errorMessage = response['error'] ?? 'Ошибка входа';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
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