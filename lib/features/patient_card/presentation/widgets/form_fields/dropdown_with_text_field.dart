import 'package:flutter/material.dart';
import 'text_input_field.dart';
import 'dropdown_field_widget.dart';

class DropdownWithTextField extends StatelessWidget {
  final String label;
  final String? selectedType;
  final TextEditingController textController;
  final List<String> dropdownItems;
  final String dropdownHint;
  final String textFieldHint;
  final bool showError;
  final String? errorText;
  final Function(String?) onTypeChanged;
  final Function(String) onTextChanged;
  final double dropdownWidth;

  const DropdownWithTextField({
    super.key,
    required this.label,
    required this.selectedType,
    required this.textController,
    required this.dropdownItems,
    required this.dropdownHint,
    required this.textFieldHint,
    required this.onTypeChanged,
    required this.onTextChanged,
    this.showError = false,
    this.errorText,
    this.dropdownWidth = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            DropdownFieldWidget<String>(
              value: selectedType,
              hint: dropdownHint,
              items: dropdownItems,
              itemLabel: (type) => type,
              onChanged: onTypeChanged,
              width: dropdownWidth,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextInputField(
                hintText: textFieldHint,
                controller: textController,
                onChanged: onTextChanged,
                showError: showError,
                errorText: errorText,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
