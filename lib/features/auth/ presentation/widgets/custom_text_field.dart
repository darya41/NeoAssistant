import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool showDivider;
  final bool isFirstField;
  final VoidCallback? onInfoPressed;
  final VoidCallback? onVisibilityPressed;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.obscureText = false,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.suffixIcon,
    this.prefixIcon,
    this.showDivider = false,
    this.isFirstField = false,
    this.onInfoPressed,
    this.onVisibilityPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isFirstField)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8),
                child: Text(
                  labelText,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),

            Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: isFirstField ? 4 : 16,
                bottom: 16,
              ),
              child: Row(
                children: [
                  if (onInfoPressed != null)
                    GestureDetector(
                      onTap: onInfoPressed,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                  if (onInfoPressed != null) const SizedBox(width: 8),

                  Expanded(
                    child: TextField(
                      controller: controller,
                      obscureText: obscureText,
                      keyboardType: keyboardType,
                      decoration: InputDecoration(
                        hintText: isFirstField ? null : labelText,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),

                  if (onVisibilityPressed != null)
                    GestureDetector(
                      onTap: onVisibilityPressed,
                      child: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),

            if (showDivider)
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: Colors.grey[300],
              ),
          ],
        ));
    }
}
