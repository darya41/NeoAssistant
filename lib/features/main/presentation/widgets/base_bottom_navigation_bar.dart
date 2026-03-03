import 'package:flutter/material.dart';

// Базовый класс с общей логикой
abstract class BaseBottomNavigationBar extends StatefulWidget {
  final int currentIndex;

  const BaseBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  // Используем ковариантный тип возврата
  @override
  State<BaseBottomNavigationBar> createState();
}

// Базовый класс состояния
abstract class BaseBottomNavigationBarState<T extends BaseBottomNavigationBar> extends State<T> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      setState(() {
        _selectedIndex = widget.currentIndex;
      });
    }
  }

  void onItemTapped(int index) async {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    await Future.delayed(const Duration(milliseconds: 50));

    if (!mounted) return;

    navigateToScreen(index);
  }

  // Абстрактный метод для навигации
  void navigateToScreen(int index);

  // Общий метод для построения элемента навигации
  Widget buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isActive = _selectedIndex == index;
    final activeColor = const Color(0xFF44E4BF);

    return InkWell(
      onTap: () => onItemTapped(index),
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isActive ? activeColor : Colors.transparent,
              border: Border.all(
                color: activeColor,
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 30,
                color: isActive ? Colors.white : activeColor,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isActive ? activeColor : Colors.grey,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // Общий метод для построения контейнера
  Widget buildContainer({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: children,
          ),
        ),
      ),
    );
  }
}