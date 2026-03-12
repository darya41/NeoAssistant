class AuthValidator {

  AuthValidator._();

  static bool isEmailValid(String email) {
    if (email.isEmpty) return false;

    return email.contains('@') &&
        email.contains('.') &&
        !email.contains(' ') &&
        email.indexOf('@') < email.lastIndexOf('.') &&
        email.length > 5;
  }

  static String? getEmailError(String email) {
    if (email.isEmpty) {
      return 'Введите email';
    }
    if (!email.contains('@')) {
      return 'Email должен содержать @';
    }
    if (!email.contains('.')) {
      return 'Email должен содержать точку';
    }
    if (email.contains(' ')) {
      return 'Email не должен содержать пробелов';
    }
    if (email.indexOf('@') > email.lastIndexOf('.')) {
      return 'Точка должна быть после @';
    }
    if (email.length < 5) {
      return 'Email слишком короткий';
    }
    return null;
  }

  static bool isPasswordValid(String password) {
    if (password.isEmpty) return false;

    return _hasMinLength(password) &&
        _hasSpecialChar(password) &&
        _hasUppercase(password) &&
        _hasDigits(password);
  }

  static bool _hasMinLength(String password) => password.length >= 12;

  static bool _hasSpecialChar(String password) =>
      password.contains(RegExp(r'[@%&]'));

  static bool _hasUppercase(String password) =>
      RegExp(r'[A-Z]').allMatches(password).length >= 2;

  static bool _hasDigits(String password) =>
      RegExp(r'[0-9]').allMatches(password).length >= 2;

  static String? getPasswordError(String password) {
    if (password.isEmpty) {
      return 'Введите пароль';
    }
    if (password.length < 12) {
      return 'Минимум 12 символов (сейчас ${password.length})';
    }
    if (!password.contains(RegExp(r'[@%&]'))) {
      return 'Добавьте спецсимвол (@, %, &)';
    }
    if (RegExp(r'[A-Z]').allMatches(password).length < 2) {
      final count = RegExp(r'[A-Z]').allMatches(password).length;
      return 'Добавьте ещё ${2 - count} заглавные буквы';
    }
    if (RegExp(r'[0-9]').allMatches(password).length < 2) {
      final count = RegExp(r'[0-9]').allMatches(password).length;
      return 'Добавьте ещё ${2 - count} цифры';
    }
    return null;
  }

  static bool doPasswordsMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  static String? getConfirmPasswordError(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Подтвердите пароль';
    }
    if (password != confirmPassword) {
      return 'Пароли не совпадают';
    }
    return null;
  }


  static bool isLoginDataValid(String email, String password) {
    return isEmailValid(email) && isPasswordValid(password);
  }

  static String? getLoginError(String email, String password) {
    final emailError = getEmailError(email);
    if (emailError != null) return emailError;

    final passwordError = getPasswordError(password);
    if (passwordError != null) return passwordError;

    return null;
  }
}