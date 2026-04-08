import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/validators/auth_validator.dart';

class RegistrationViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  int _currentStep = 0;
  bool _isLoading = false;
  int? _selectedPositionId;
  String? _errorMessage;

  int get currentStep => _currentStep;
  bool get isLoading => _isLoading;
  int? get selectedPositionId => _selectedPositionId;
  String? get errorMessage => _errorMessage;

  bool get isStep1Valid {
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (!AuthValidator.isEmailValid(email)) return false;
    if (!AuthValidator.isPasswordValid(password)) return false;
    if (!AuthValidator.doPasswordsMatch(password, confirmPassword)) return false;

    return true;
  }

  bool get isStep2Valid {
    return lastNameController.text.trim().isNotEmpty &&
        firstNameController.text.trim().isNotEmpty;
  }

  bool get isStep3Valid {
    final digits = phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
    return digits.length == 12;
  }

  bool get isStep4Valid {
    return _selectedPositionId != null;
  }

  String? get emailError {
    final email = emailController.text;
    if (email.isEmpty) return null;
    return AuthValidator.getEmailError(email);
  }

  String? get passwordError {
    final password = passwordController.text;
    if (password.isEmpty) return null;
    return AuthValidator.getPasswordError(password);
  }

  String? get confirmPasswordError {
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    if (confirmPassword.isEmpty) return null;
    if (!AuthValidator.doPasswordsMatch(password, confirmPassword)) {
      return 'Пароли не совпадают';
    }
    return null;
  }

  String? get phoneError {
    final phone = phoneController.text;
    if (phone.isEmpty) return null;
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length != 12) {
      return 'Введите номер в формате +375XXXXXXXXX';
    }
    return null;
  }

  RegistrationViewModel() {
    emailController.addListener(_onFormChanged);
    passwordController.addListener(_onFormChanged);
    confirmPasswordController.addListener(_onFormChanged);
    lastNameController.addListener(_onFormChanged);
    firstNameController.addListener(_onFormChanged);
    middleNameController.addListener(_onFormChanged);
    phoneController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    notifyListeners();
  }

  void nextStep() {
    if (_currentStep == 0 && isStep1Valid) {
      _currentStep++;
      notifyListeners();
    } else if (_currentStep == 1 && isStep2Valid) {
      _currentStep++;
      notifyListeners();
    } else if (_currentStep == 2 && isStep3Valid) {
      _currentStep++;
      notifyListeners();
    } else if (_currentStep == 3 && isStep4Valid) {
      _completeRegistration();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void selectPosition(int positionId) {
    _selectedPositionId = positionId;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> _completeRegistration() async {
    String phoneDigits = phoneController.text
        .replaceAll(RegExp(r'[^\d]'), '')
        .substring(3);

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authRepository.register(
        email: emailController.text.trim(),
        password: passwordController.text,
        lastName: lastNameController.text.trim(),
        firstName: firstNameController.text.trim(),
        middleName: middleNameController.text.trim().isEmpty
            ? null
            : middleNameController.text.trim(),
        phone: '+375$phoneDigits',
        positionId: _selectedPositionId!,
      );

      _isLoading = false;
      notifyListeners();

      return result['success'] == true;

    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> register() async {
    return await _completeRegistration();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void reset() {
    _currentStep = 0;
    _selectedPositionId = null;
    _isLoading = false;
    _errorMessage = null;

    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    lastNameController.clear();
    firstNameController.clear();
    middleNameController.clear();
    phoneController.clear();

    notifyListeners();
  }

  @override
  void dispose() {
    emailController.removeListener(_onFormChanged);
    passwordController.removeListener(_onFormChanged);
    confirmPasswordController.removeListener(_onFormChanged);
    lastNameController.removeListener(_onFormChanged);
    firstNameController.removeListener(_onFormChanged);
    middleNameController.removeListener(_onFormChanged);
    phoneController.removeListener(_onFormChanged);

    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    lastNameController.dispose();
    firstNameController.dispose();
    middleNameController.dispose();
    phoneController.dispose();

    super.dispose();
  }
}