import 'package:flutter/material.dart';
import 'package:neo_friend/features/calculator/presentation/pages/calculators_screen.dart';
import '../../../../profile/presentation/pages/doctor_profile_screen.dart';
import '../../pages/home_screen.dart';
import '../../../../reminders/presentation/pages/reminders_screen.dart';
import 'base_bottom_navigation_bar.dart';

class AnalyticsBottomBar extends BaseBottomNavigationBar {
  final bool isGuest;

  const AnalyticsBottomBar({
    super.key,
    required super.currentIndex,
    this.isGuest = false,
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
          MaterialPageRoute(builder: (context) => const HomeScreen(title: 'Главная', initialTab: 'Аналитика',)),
        );
        break;
      case 1:
        if (widget.isGuest) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Гостям доступна только аналитика'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RemindersPageScreen(useAnalyticsBottomBar: true,)),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CalculatorsScreen()),
        );
        break;
      case 3:
        if (widget.isGuest) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Гостям доступна только аналитика'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DoctorProfileScreen(useAnalyticsBottomBar: true,)),
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