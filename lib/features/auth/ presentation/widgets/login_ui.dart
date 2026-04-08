import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'error_container.dart';
import 'login_form.dart';

class LoginUI extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLoginPressed;
  final VoidCallback onCreateAccountPressed;
  final String? errorMessage;
  final bool isLoading;
  final bool isFormValid;
  final String? emailError;
  final String? passwordError;
  final VoidCallback? onClearError;

  const LoginUI({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginPressed,
    required this.onCreateAccountPressed,
    this.errorMessage,
    required this.isLoading,
    required this.isFormValid,
    this.emailError,
    this.passwordError,
    this.onClearError,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              const Text(
                'Авторизация',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 20),

              ErrorContainer(errorMessage: errorMessage),

              LoginForm(
                emailController: emailController,
                passwordController: passwordController,
                onLoginPressed: onLoginPressed,
                isLoading: isLoading,
                isFormValid: isFormValid,
                emailError: emailError,
                passwordError: passwordError,
                onClearError: onClearError,
              ),

              const SizedBox(height: 60),

              Center(
                child: Column(
                  children: [
                    const Text(
                      'Ещё нет аккаунта?',
                      style: TextStyle(fontSize: 14, color: AppColors.grey),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: onCreateAccountPressed,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: const Text(
                        'Создать аккаунт',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}