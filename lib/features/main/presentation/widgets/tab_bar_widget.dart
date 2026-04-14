import 'package:flutter/material.dart';
import 'package:neo_friend/core/constants/app_colors.dart';

class TabBarWidget extends StatefulWidget {
  final String activeTab;
  final Function(String) onTabChanged;
  final bool isGuest;

  const TabBarWidget({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
    this.isGuest = false,
  });

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.primary,
      child: Row(
        children: [
          if (!widget.isGuest)
            Expanded(
              child: _buildTabButton(
                text: 'Картотека',
                isActive: widget.activeTab == 'Картотека',
                onTap: () => widget.onTabChanged('Картотека'),
                isFirst: true,
                isLast: false,
              ),
            ),
          Expanded(
            child: _buildTabButton(
              text: 'Аналитика',
              isActive: widget.activeTab == 'Аналитика',
              onTap: () => widget.onTabChanged('Аналитика'),
              isFirst: widget.isGuest,
              isLast: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String text,
    required bool isActive,
    required VoidCallback onTap,
    required bool isFirst,
    required bool isLast,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF7FEBD4) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: isFirst ? const Radius.circular(15) : Radius.zero,
            bottomLeft: isFirst ? const Radius.circular(15) : Radius.zero,
            topRight: isLast ? const Radius.circular(15) : Radius.zero,
            bottomRight: isLast ? const Radius.circular(15) : Radius.zero,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isActive ? Colors.black : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}