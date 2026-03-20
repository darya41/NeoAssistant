 import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final int maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixTap;
  final Function(String)? onChanged;
  final String? errorText;
  final bool showError;
  final bool readOnly;
  final VoidCallback? onTap;

  static const _defaultBackgroundColor = Color(0xFFF3F3F3);
  static const _borderColor = Color(0xFFC6C6C6);
  static const _errorBorderColor = Colors.red;

  const TextInputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.onChanged,
    this.errorText,
    this.showError = false,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = showError && errorText != null
        ? _errorBorderColor
        : _borderColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: maxLines > 1 ? 12 : 4),
        decoration: BoxDecoration(
          color: _defaultBackgroundColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (prefixIcon != null) ...[
              prefixIcon!,
              const SizedBox(width: 8),
            ],
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                maxLines: maxLines,
                readOnly: readOnly,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            if (suffixIcon != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onSuffixTap,
                child: suffixIcon,
              ),
            ],
          ],
        ),
      ),
    );
  }
}