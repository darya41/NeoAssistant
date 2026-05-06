import 'package:flutter/material.dart';

class ContinueButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isEnabled;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final Color? borderColor;

  const ContinueButton({
    super.key,
    required this.onPressed,
    required this.isEnabled,
    this.text = 'Продолжить',
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBgColor = const Color(0xFF44E4BF);
    const defaultTextColor = Colors.white;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? (backgroundColor ?? defaultBgColor)
              : Colors.grey[400],
          foregroundColor: isEnabled
              ? (textColor ?? defaultTextColor)
              : Colors.grey[600],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: 1.5)
                : BorderSide.none,
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}