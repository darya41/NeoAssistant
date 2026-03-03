import 'package:flutter/material.dart';

class TabBarWidget extends StatefulWidget {
  final String activeTab;
  final Function(String) onTabChanged;

  const TabBarWidget({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Color(0xFF44E4BF),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              text: 'Картотека',
              isActive: widget.activeTab == 'Картотека',
              onTap: () => widget.onTabChanged('Картотека'),
            ),
          ),
          Expanded(
            child: _buildTabButton(
              text: 'Аналитика',
              isActive: widget.activeTab == 'Аналитика',
              onTap: () => widget.onTabChanged('Аналитика'),
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
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: isActive ? Color(0xFF7FEBD4) : Colors.white,
          borderRadius: BorderRadius.horizontal(
            left: text == 'Картотека' ? Radius.circular(15) : Radius.zero,
            right: text == 'Аналитика' ? Radius.circular(15) : Radius.zero,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isActive ? Colors.black : Color(0xFF44E4BF),
            ),
          ),
        ),
      ),
    );
  }
}
