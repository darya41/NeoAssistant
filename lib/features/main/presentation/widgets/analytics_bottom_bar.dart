import 'package:flutter/material.dart';
import '../pages/doctor_profile_screen.dart';
import '../pages/home_screen.dart';
import '../pages/reminders_screen.dart';
import '../pages/templates_screen.dart';
import 'base_bottom_navigation_bar.dart';

class AnalyticsBottomBar extends BaseBottomNavigationBar {
  const AnalyticsBottomBar({
    super.key,
    required super.currentIndex,
  });

  @override
  State<AnalyticsBottomBar> createState() => _AnalyticsBottomBarState();
}

class _AnalyticsBottomBarState extends BaseBottomNavigationBarState<AnalyticsBottomBar> {
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
          icon: Icons.lightbulb_outline,
          label: 'знания',
          index: 0,
        ),
        buildNavItem(
          icon: Icons.calendar_month,
          label: 'напоминания',
          index: 1,
        ),
        buildNavItem(
          icon: Icons.calculate_outlined,
          label: 'калькулятор',
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