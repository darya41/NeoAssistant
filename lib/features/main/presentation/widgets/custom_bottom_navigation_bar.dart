import 'package:flutter/material.dart';
import '../pages/doctor_profile_screen.dart';
import '../pages/home_screen.dart';
import '../pages/reminders_screen.dart';
import '../pages/templates_screen.dart';
import 'base_bottom_navigation_bar.dart';

class CustomBottomNavigationBar extends BaseBottomNavigationBar {
  const CustomBottomNavigationBar({
    super.key,
    required super.currentIndex,
  });

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends BaseBottomNavigationBarState<CustomBottomNavigationBar> {
  @override
  void navigateToScreen(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen(title: 'Главная')),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RemindersPageScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TemplatesScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DoctorProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildContainer(
      children: [
        buildNavItem(
          icon: Icons.home_filled,
          label: 'главная',
          index: 0,
        ),
        buildNavItem(
          icon: Icons.calendar_month,
          label: 'напоминания',
          index: 1,
        ),
        buildNavItem(
          icon: Icons.table_chart_sharp,
          label: 'шаблоны',
          index: 2,
        ),
        buildNavItem(
          icon: Icons.person,
          label: 'профиль',
          index: 3,
        ),
      ],
    );
  }
}