import 'package:flutter/material.dart';
import 'login_form.dart';

class LoginUI extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLoginPressed;
  final VoidCallback onCreateAccountPressed;

  const LoginUI({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginPressed,
    required this.onCreateAccountPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                ),
              ),

              const SizedBox(height: 40),

              LoginForm(
                emailController: emailController,
                passwordController: passwordController,
                onLoginPressed: onLoginPressed,
              ),

              const SizedBox(height: 60),

              Center(
                child: Column(
                  children: [
                    const Text(
                      'Ещё нет аккаунта?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: onCreateAccountPressed,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Создать аккаунт',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF44E4BF),
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