import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../shared/widgets/buttons/continue_button.dart';
import 'error_container.dart';
import 'form_field_container.dart';

class RegistrationStep3 extends StatefulWidget {
  final TextEditingController phoneController;
  final VoidCallback onComplete;
  final bool isStepValid;
  final String? phoneError;
  final VoidCallback? onClearError;

  const RegistrationStep3({
    super.key,
    required this.phoneController,
    required this.onComplete,
    required this.isStepValid,
    this.phoneError,
    this.onClearError,
  });

  @override
  State<RegistrationStep3> createState() => _RegistrationStep3State();
}

class _RegistrationStep3State extends State<RegistrationStep3> {
  final FocusNode _phoneFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.phoneController.text.isEmpty) {
      widget.phoneController.text = '+375 (';
    }
  }

  @override
  void dispose() {
    _phoneFocusNode.dispose();
    super.dispose();
  }

  void _formatPhoneNumber(String value) {
    final text = value.replaceAll(RegExp(r'[^\d+()\-\s]'), '');

    if (text.isEmpty) {
      widget.phoneController.text = '+375 (';
      widget.phoneController.selection = TextSelection.collapsed(offset: 6);
      return;
    }

    if (!text.startsWith('+375 (')) {
      widget.phoneController.text = '+375 (';
      widget.phoneController.selection = TextSelection.collapsed(offset: 6);
      return;
    }

    String digits = text.substring(6).replaceAll(RegExp(r'[^\d]'), '');

    if (digits.length > 9) {
      digits = digits.substring(0, 9);
    }

    String formatted = '+375 (';

    if (digits.isNotEmpty) {
      formatted += digits.substring(0, digits.length > 2 ? 2 : digits.length);
    }

    if (digits.length >= 3) {
      formatted += ') ';
      formatted += digits.substring(2, digits.length > 5 ? 5 : digits.length);
    }

    if (digits.length >= 6) {
      formatted += '-';
      formatted += digits.substring(5, digits.length > 7 ? 7 : digits.length);
    }

    if (digits.length >= 8) {
      formatted += '-';
      formatted += digits.substring(7);
    }

    widget.phoneController.text = formatted;
    widget.phoneController.selection = TextSelection.collapsed(offset: formatted.length);
  }

  bool _isPhoneComplete() {
    final text = widget.phoneController.text;
    final digits = text.replaceAll(RegExp(r'\D'), '');
    return digits.length == 12;
  }

  @override
  Widget build(BuildContext context) {
    final isPhoneValid = _isPhoneComplete();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Шаг 2/3',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            ErrorContainer(errorMessage: widget.phoneError),

            FormFieldContainer(
              children: [
                GestureDetector(
                  onTap: widget.onClearError,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: TextField(
                      controller: widget.phoneController,
                      focusNode: _phoneFocusNode,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [LengthLimitingTextInputFormatter(19)],
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '+375 (--) --- -- --',
                        hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      style: TextStyle(fontSize: 16, letterSpacing: 0.5),
                      onChanged: (value) {
                        _formatPhoneNumber(value);
                        widget.onClearError?.call();
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ContinueButton(
              onPressed: isPhoneValid ? widget.onComplete : null,
              isEnabled: isPhoneValid,
            ),
          ],
        ),
      ),
    );
  }
}