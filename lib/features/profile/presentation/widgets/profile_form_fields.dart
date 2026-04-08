import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/validators/profile_validator.dart';
import '../../../../shared/widgets/fields/text_input_field.dart';

class ProfileFormFields extends StatefulWidget {
  final TextEditingController lastNameController;
  final TextEditingController firstNameController;
  final TextEditingController patronymicController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController phoneController;
  final bool isEmailEditable;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;

  const ProfileFormFields({
    super.key,
    required this.lastNameController,
    required this.firstNameController,
    required this.patronymicController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.phoneController,
    this.isEmailEditable = true,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
  });

  @override
  State<ProfileFormFields> createState() => _ProfileFormFieldsState();
}

class _ProfileFormFieldsState extends State<ProfileFormFields> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _passwordChanged = false;

  @override
  void initState() {
    super.initState();
    widget.passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    widget.passwordController.removeListener(_onPasswordChanged);
    super.dispose();
  }

  void _onPasswordChanged() {
    setState(() {
      _passwordChanged = ProfileValidator.isPasswordChanged(
        widget.passwordController.text,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextInputField(
          controller: widget.lastNameController,
          hintText: 'Фамилия',
        ),
        const SizedBox(height: 16),
        TextInputField(
          controller: widget.firstNameController,
          hintText: 'Имя',
        ),
        const SizedBox(height: 16),
        TextInputField(
          controller: widget.patronymicController,
          hintText: 'Отчество',
        ),
        const SizedBox(height: 16),
        TextInputField(
          controller: widget.emailController,
          hintText: 'Email',
          keyboardType: TextInputType.emailAddress,
          readOnly: !widget.isEmailEditable,
          showError: widget.emailError != null,
          errorText: widget.emailError,
        ),
        const SizedBox(height: 16),
        _buildPasswordField('Новый пароль', widget.passwordController, isConfirm: false),
        const SizedBox(height: 16),
        _buildPasswordField('Подтвердите пароль', widget.confirmPasswordController, isConfirm: true),
        const SizedBox(height: 16),
        TextInputField(
          controller: widget.phoneController,
          hintText: 'Телефон',
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, {required bool isConfirm}) {
    final isVisible = isConfirm ? _isConfirmPasswordVisible : _isPasswordVisible;
    final errorText = isConfirm
        ? (widget.confirmPasswordError ?? ProfileValidator.validatePasswordMatch(
      widget.passwordController.text,
      widget.confirmPasswordController.text,
    ))
        : (_passwordChanged
        ? (widget.passwordError ?? ProfileValidator.validatePassword(controller.text))
        : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: !isVisible,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              hintText: label,
              hintStyle: const TextStyle(color: Colors.grey),
              suffixIcon: IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    if (isConfirm) {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    } else {
                      _isPasswordVisible = !_isPasswordVisible;
                    }
                  });
                },
              ),
            ),
          ),
        ),
        if (errorText != null && errorText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Text(
              errorText,
              style: const TextStyle(color: AppColors.error, fontSize: 12),
            ),
          ),
      ],
    );
  }
}