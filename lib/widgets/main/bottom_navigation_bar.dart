import 'package:flutter/material.dart';
import '../../screens/main/doctor_profile_screen.dart';
import '../../screens/main/home_screen.dart';
import '../../screens/main/reminders_page_screen.dart';
import '../../screens/main/templates_screen.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  @override
  void didUpdateWidget(covariant CustomBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      setState(() {
        _selectedIndex = widget.currentIndex;
      });
    }
  }

  void _onItemTapped(int index) async {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    await Future.delayed(const Duration(milliseconds: 50));

    if (!mounted) return;

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
            children: [
              _buildBottomNavItem(
                icon: Icons.home_filled,
                label: 'главная',
                isActive: _selectedIndex == 0,
                onTap: () => _onItemTapped(0),
              ),
              _buildBottomNavItem(
                icon: Icons.calendar_month,
                label: 'напоминания',
                isActive: _selectedIndex == 1,
                onTap: () => _onItemTapped(1),
              ),
              _buildBottomNavItem(
                icon: Icons.table_chart_sharp,
                label: 'шаблоны',
                isActive: _selectedIndex == 2,
                onTap: () => _onItemTapped(2),
              ),
              _buildBottomNavItem(
                icon: Icons.person,
                label: 'профиль',
                isActive: _selectedIndex == 3,
                onTap: () => _onItemTapped(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final activeColor = const Color(0xFF44E4BF);

    return InkWell(
      onTap: onTap,
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
}