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
  final VoidCallback? onClearError;
  final VoidCallback onGuestLoginPressed;

  const LoginUI({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginPressed,
    required this.onCreateAccountPressed,
    required this.onGuestLoginPressed,
    this.errorMessage,
    required this.isLoading,
    required this.isFormValid,
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
                onClearError: onClearError,
              ),

              const SizedBox(height: 16),

              OutlinedButton(
                onPressed: onGuestLoginPressed,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Продолжить как гость',
                  style: TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 40),

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