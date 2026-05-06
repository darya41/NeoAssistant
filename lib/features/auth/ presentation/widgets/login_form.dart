import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/icon_widgets.dart';
import '../../../../shared/widgets/buttons/continue_button.dart';
import 'error_container.dart';

class LoginForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLoginPressed;
  final bool isLoading;
  final bool isFormValid;
  final String? errorMessage;
  final VoidCallback? onClearError;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginPressed,
    required this.isLoading,
    required this.isFormValid,
    this.errorMessage,
    this.onClearError,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscurePassword = true;

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
              _buildPasswordField(),
            ],
          ),
        ),

        if (widget.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: ErrorContainer(errorMessage: widget.errorMessage),
          ),

        const SizedBox(height: 40),

        if (widget.isLoading)
          const Center(child: CircularProgressIndicator())
        else
          ContinueButton(
            onPressed: widget.onLoginPressed,
            isEnabled: widget.isFormValid,
          ),
      ],
    );
  }

  Widget _buildEmailField() {
    return GestureDetector(
      onTap: widget.onClearError,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: TextField(
          controller: widget.emailController,
          keyboardType: TextInputType.emailAddress,
          textAlignVertical: TextAlignVertical.center,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
            hintText: 'Электронная почта',
            hintStyle: TextStyle(fontSize: 16, color: AppColors.grey),
          ),
          style: const TextStyle(fontSize: 16),
          onChanged: (_) {
            widget.onClearError?.call();
          },
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return GestureDetector(
      onTap: widget.onClearError,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.passwordController,
                obscureText: _obscurePassword,
                textAlignVertical: TextAlignVertical.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  hintText: 'Пароль',
                  hintStyle: TextStyle(fontSize: 16, color: AppColors.grey),
                ),
                style: const TextStyle(fontSize: 16),
                onChanged: (_) {
                  widget.onClearError?.call();
                },
              ),
            ),
            IconWidgets.visibilityIcon(
              isVisible: _obscurePassword,
              onTap: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ],
        ),
      ),
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