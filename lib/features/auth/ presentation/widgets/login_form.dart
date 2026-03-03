import 'package:flutter/material.dart';
import 'password_rules.dart';
import '../../../../core/utils/icon_widgets.dart';
import '../../../../shared/widgets/buttons/continue_button.dart';

class LoginForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLoginPressed;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginPressed,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscurePassword = true;
  bool _isButtonEnabled = false;

  final Color _primaryColor = const Color(0xFF44E4BF);
  final Color _disabledColor = Colors.grey[400]!;

  @override
  void initState() {
    super.initState();
    widget.emailController.addListener(_validateFields);
    widget.passwordController.addListener(_validateFields);
  }

  @override
  void dispose() {
    widget.emailController.removeListener(_validateFields);
    widget.passwordController.removeListener(_validateFields);
    super.dispose();
  }

  void _validateFields() {
    final email = widget.emailController.text.trim();
    final password = widget.passwordController.text.trim();

    final bool isValid = email.isNotEmpty && password.isNotEmpty;

    if (_isButtonEnabled != isValid) {
      setState(() {
        _isButtonEnabled = isValid;
      });
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }



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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
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
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  onChanged: (value) {
                    _validateFields();
                  },
                ),
              ),

              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: Colors.grey[300],
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
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
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                          hintText: 'Пароль',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        onChanged: (value) {
                          _validateFields();
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
            ],
          ),
        ),

        const SizedBox(height: 40),

        ContinueButton(
          onPressed: widget.onLoginPressed,
          isEnabled: _isButtonEnabled,
        ),
      ],
    );
  }
}