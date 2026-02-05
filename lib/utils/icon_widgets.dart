import 'package:flutter/material.dart';

class IconWidgets {
  static Widget infoIcon({
    required BuildContext context,
    required VoidCallback onTap,
    double size = 24,
    Color backgroundColor = const Color(0xFFE0E0E0),
    Color iconColor = Colors.grey,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        child: Icon(
          Icons.info_outline,
          size: size * 0.67,
          color: iconColor,
        ),
      ),
    );
  }

  static Widget visibilityIcon({
    required bool isVisible,
    required VoidCallback onTap,
    double size = 20,
    Color color = Colors.grey,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isVisible ? Icons.visibility_off : Icons.visibility,
        color: color,
        size: size,
      ),
    );
  }

  static Widget searchIcon({
    required VoidCallback onTap,
    double size = 20,
    Color color = Colors.grey,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Icon(
          Icons.search,
          color: color,
          size: size,
        ),
      ),
    );
  }
}