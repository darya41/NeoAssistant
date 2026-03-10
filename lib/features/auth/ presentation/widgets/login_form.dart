import 'package:flutter/material.dart';
import 'password_rules.dart';
import '../../../../core/utils/icon_widgets.dart';
import '../../../../shared/widgets/buttons/continue_button.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLoginPressed;
  final bool isLoading;
  final bool isFormValid;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginPressed,
    required this.isLoading,
    required this.isFormValid,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildEmailField(),
              _buildDivider(),
              _buildPasswordField(context),
            ],
          ),
        ),

        const SizedBox(height: 40),

        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else
          ContinueButton(
            onPressed: isFormValid ? onLoginPressed : null,
            isEnabled: isFormValid,
          ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        textAlignVertical: TextAlignVertical.center,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
          hintText: 'Электронная почта',
          hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool obscurePassword = true;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              IconWidgets.infoIcon(
                context: context,
                onTap: () => PasswordRulesDialog.show(context),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    hintText: 'Пароль',
                    hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              IconWidgets.visibilityIcon(
                isVisible: obscurePassword,
                onTap: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.grey[300],
    );
  }
}