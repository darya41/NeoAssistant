import 'package:flutter/material.dart';

class IconWidgets {
  static const double _defaultIconSize = 24.0;
  static const double _smallIconSize = 20.0;
  static const double _largeIconSize = 26.0;

  static const _defaultBackgroundColor = Color(0xFFE0E0E0);
  static const _iconColor = Colors.black;

  static Widget infoIcon({
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _defaultIconSize,
        height: _defaultIconSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _defaultBackgroundColor,
        ),
        child: Icon(
          Icons.info_outline,
          size: _defaultIconSize,
          color: _iconColor,
        ),
      ),
    );
  }

  static Widget visibilityIcon({
    required bool isVisible,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        color: _iconColor,
        size: _defaultIconSize,
      ),
    );
  }

  static Widget searchIcon({
    required VoidCallback onTap,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Icon(
          Icons.search,
          color: _iconColor,
          size: _smallIconSize,
        ),
      ),
    );
  }

  static Widget micIcon({
    required VoidCallback onTap,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Icon(
          Icons.mic_none_sharp,
          size: _largeIconSize ,
          color: _iconColor,
        ),
      ),
    );
  }

  static Widget filterIcon({
    required VoidCallback onTap,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Icon(
          Icons.filter_list,
          size: _smallIconSize,
          color: _iconColor,
        ),
      ),
    );
  }

  static Widget addIcon({
    required VoidCallback onTap,
    Color backgroundColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _defaultIconSize,
        height: _defaultIconSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        child: Icon(
          Icons.add,
          size: _defaultIconSize,
          color: _iconColor,
        ),
      ),
    );
  }


}