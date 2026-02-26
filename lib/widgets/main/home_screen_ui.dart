import 'package:flutter/material.dart';
import 'reminders_stats.dart';
import 'tab_bar_widget.dart';
import 'search_field.dart';
import 'bottom_navigation_bar.dart';
import 'patient_cards.dart';
import 'protocols_list.dart';

class HomeScreenUI extends StatefulWidget {
  const HomeScreenUI({super.key});

  @override
  State<HomeScreenUI> createState() => _HomeScreenUIState();
}

class _HomeScreenUIState extends State<HomeScreenUI> {
  String _activeTab = 'Картотека';

  void _onTabChanged(String tab) {
    setState(() {
      _activeTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const RemindersStats(),
            TabBarWidget(
              activeTab: _activeTab,
              onTabChanged: _onTabChanged,
            ),
            const SearchField(),
            Expanded(
              child: _activeTab == 'Картотека'
                  ? PatientCards()
                  : ProtocolsList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar( currentIndex: 0,),
    );
  }
}
