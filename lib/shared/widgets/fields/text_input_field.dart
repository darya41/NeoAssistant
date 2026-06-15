 import 'package:flutter/material.dart';
import 'package:neo_friend/core/constants/app_colors.dart';

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
        ? AppColors.error
        : AppColors.neutral_25;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: maxLines > 1 ? 12 : 4),
        decoration: BoxDecoration(
          color: AppColors.neutral_5,
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