import 'package:flutter/material.dart';
import '../../../../core/validators/auth_validator.dart';
import 'password_rules.dart';
import '../../../../core/utils/icon_widgets.dart';
import '../../../../shared/widgets/buttons/continue_button.dart';

class RegistrationStep1 extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onNextStep;
  final bool isStepValid;

  const RegistrationStep1({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onNextStep,
    required this.isStepValid,
  });

  @override
  State<RegistrationStep1> createState() => _RegistrationStep1State();
}

class _RegistrationStep1State extends State<RegistrationStep1> {
  bool _obscurePassword = true;
  final bool _obscureConfirmPassword = true;

  String? get _emailError {
    final email = widget.emailController.text;
    if (email.isEmpty) return null;
    return AuthValidator.getEmailError(email);
  }

  String? get _passwordError {
    final password = widget.passwordController.text;
    if (password.isEmpty) return null;
    return AuthValidator.getPasswordError(password);
  }

  String? get _confirmError {
    final confirm = widget.confirmPasswordController.text;
    if (confirm.isEmpty) return null;
    return AuthValidator.getConfirmPasswordError(
      widget.passwordController.text,
      confirm,
    );
  }

  String? get _firstError {
    if (_emailError != null) return _emailError;
    if (_passwordError != null) return _passwordError;
    if (_confirmError != null) return _confirmError;
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
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            if (_firstError != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _firstError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: TextField(
                      controller: widget.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Электронная почта',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 16),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),

                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    color: Colors.grey[300],
                  ),

                  Padding(
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
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                            style: const TextStyle(fontSize: 16),
                            onChanged: (_) => setState(() {}),
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

                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    color: Colors.grey[300],
                  ),

                  Padding(
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
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                            style: const TextStyle(fontSize: 16),
                            onChanged: (_) => setState(() {}),
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
                ],
              ),
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
}