import 'package:flutter/material.dart';
import '../../../../shared/widgets/buttons/continue_button.dart';
import 'checkbox_agreement.dart';
import 'error_container.dart';
import 'form_field_container.dart';

class RegistrationStep2 extends StatefulWidget {
  final TextEditingController lastNameController;
  final TextEditingController firstNameController;
  final TextEditingController middleNameController;
  final VoidCallback onNextStep;
  final bool isStepValid;
  final String? lastNameError;
  final String? firstNameError;
  final VoidCallback? onClearError;

  const RegistrationStep2({
    super.key,
    required this.lastNameController,
    required this.firstNameController,
    required this.middleNameController,
    required this.onNextStep,
    required this.isStepValid,
    this.lastNameError,
    this.firstNameError,
    this.onClearError,
  });

  @override
  State<RegistrationStep2> createState() => _RegistrationStep2State();
}

class _RegistrationStep2State extends State<RegistrationStep2> {
  bool _agreementChecked = false;

  String? get _firstError {
    if (widget.lastNameError != null) return widget.lastNameError;
    if (widget.firstNameError != null) return widget.firstNameError;
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
              'Шаг 1/3',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            ErrorContainer(errorMessage: _firstError),

            FormFieldContainer(
              children: [
                _buildTextField(widget.lastNameController, 'Фамилия'),
                _buildDivider(),
                _buildTextField(widget.firstNameController, 'Имя'),
                _buildDivider(),
                _buildTextField(widget.middleNameController, 'Отчество (необязательно)'),
              ],
            ),
            const SizedBox(height: 40),

            ContinueButton(
              onPressed: (widget.isStepValid && _agreementChecked) ? widget.onNextStep : null,
              isEnabled: widget.isStepValid && _agreementChecked,
            ),

            const SizedBox(height: 20),

            CheckboxAgreement(
              value: _agreementChecked,
              onChanged: (value) => setState(() => _agreementChecked = value ?? false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return GestureDetector(
      onTap: widget.onClearError,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
          style: const TextStyle(fontSize: 16),
          onChanged: (_) => widget.onClearError?.call(),
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