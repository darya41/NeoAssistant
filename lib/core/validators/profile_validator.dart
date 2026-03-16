import 'auth_validator.dart';

class ProfileValidator {
  ProfileValidator._();

  static bool isRequiredFieldsValid({
    required String lastName,
    required String firstName,
    required String email,
  }) {
    return lastName.isNotEmpty &&
        firstName.isNotEmpty &&
        email.isNotEmpty;
  }

  static bool isPasswordChanged(String password) {
    return password.isNotEmpty;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) return null;
    return AuthValidator.getPasswordError(password);
  }

  static String? validatePasswordMatch(String password, String confirmPassword) {
    if (password.isEmpty && confirmPassword.isEmpty) return null;
    return AuthValidator.getConfirmPasswordError(password, confirmPassword);
  }

  static bool isFormValid({
    required String lastName,
    required String firstName,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    if (!isRequiredFieldsValid(
      lastName: lastName,
      firstName: firstName,
      email: email,
    )) return false;

    if (!AuthValidator.isEmailValid(email)) return false;

    if (isPasswordChanged(password)) {
      if (validatePassword(password) != null) return false;
      if (validatePasswordMatch(password, confirmPassword) != null) return false;
    }

    return true;
  }

  static Map<String, dynamic> getUpdatedData({
    required String lastName,
    required String firstName,
    required String patronymic,
    required String email,
    required String phone,
    required String position,
    required String password,
  }) {
    final data = {
      'lastName': lastName,
      'firstName': firstName,
      'patronymic': patronymic,
      'email': email,
      'phone': phone,
      'position': position,
    };

    if (isPasswordChanged(password)) {
      data['password'] = password;
    }

    return data;
  }
}