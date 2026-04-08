import 'package:flutter/material.dart';
import 'error_container.dart';
import 'form_field_container.dart';
import 'password_rules.dart';
import '../../../../core/utils/icon_widgets.dart';
import '../../../../shared/widgets/buttons/continue_button.dart';

class RegistrationStep1 extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onNextStep;
  final bool isStepValid;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final VoidCallback? onClearError;

  const RegistrationStep1({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onNextStep,
    required this.isStepValid,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.onClearError,
  });

  @override
  State<RegistrationStep1> createState() => _RegistrationStep1State();
}

class _RegistrationStep1State extends State<RegistrationStep1> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? get _firstError {
    if (widget.emailError != null) return widget.emailError;
    if (widget.passwordError != null) return widget.passwordError;
    if (widget.confirmPasswordError != null) return widget.confirmPasswordError;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Регистрация',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            ErrorContainer(errorMessage: _firstError),

            FormFieldContainer(
              children: [
                _buildEmailField(),
                _buildDivider(),
                _buildPasswordField(context),
                _buildDivider(),
                _buildConfirmPasswordField(),
              ],
            ),

            const SizedBox(height: 40),

            ContinueButton(
              onPressed: widget.onNextStep,
              isEnabled: widget.isStepValid,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return GestureDetector(
      onTap: widget.onClearError,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Электронная почта',
            hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
          style: TextStyle(fontSize: 16),
          keyboardType: TextInputType.emailAddress,
        ),
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClearError,
      child: Padding(
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
                controller: widget.passwordController,
                obscureText: _obscurePassword,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Пароль',
                  hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                style: const TextStyle(fontSize: 16),
                onChanged: (_) => widget.onClearError?.call(),
              ),
            ),
            IconWidgets.visibilityIcon(
              isVisible: _obscurePassword,
              onTap: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return GestureDetector(
      onTap: widget.onClearError,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const SizedBox(width: 32),
            Expanded(
              child: TextField(
                controller: widget.confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Повторить пароль',
                  hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                style: const TextStyle(fontSize: 16),
                onChanged: (_) => widget.onClearError?.call(),
              ),
            ),
            IconWidgets.visibilityIcon(
              isVisible: _obscureConfirmPassword,
              onTap: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
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