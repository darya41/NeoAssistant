import 'package:flutter/material.dart';
import '../../../../core/validators/profile_validator.dart';

class ProfileFormFields extends StatefulWidget {
  final TextEditingController lastNameController;
  final TextEditingController firstNameController;
  final TextEditingController patronymicController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController phoneController;

  const ProfileFormFields({
    super.key,
    required this.lastNameController,
    required this.firstNameController,
    required this.patronymicController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.phoneController,
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
        _buildTextField('Фамилия', widget.lastNameController),
        const SizedBox(height: 16),
        _buildTextField('Имя', widget.firstNameController),
        const SizedBox(height: 16),
        _buildTextField('Отчество', widget.patronymicController),
        const SizedBox(height: 16),
        _buildTextField('Email', widget.emailController, keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 16),
        _buildPasswordField('Новый пароль', widget.passwordController, isConfirm: false),
        const SizedBox(height: 16),
        _buildPasswordField('Подтвердите пароль', widget.confirmPasswordController, isConfirm: true),
        const SizedBox(height: 16),
        _buildTextField('Телефон', widget.phoneController, keyboardType: TextInputType.phone),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          hintText: label,
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, {required bool isConfirm}) {
    final errorText = isConfirm
        ? ProfileValidator.validatePasswordMatch(
      widget.passwordController.text,
      widget.confirmPasswordController.text,
    )
        : _passwordChanged
        ? ProfileValidator.validatePassword(controller.text)
        : null;

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
            obscureText: isConfirm ? !_isConfirmPasswordVisible : !_isPasswordVisible,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              hintText: label,
              hintStyle: const TextStyle(color: Colors.grey),
              suffixIcon: IconButton(
                icon: Icon(
                  isConfirm
                      ? (_isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility)
                      : (_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
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
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}