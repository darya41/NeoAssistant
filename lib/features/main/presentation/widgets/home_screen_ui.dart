import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'reminders_stats.dart';
import 'tab_bar_widget.dart';
import 'search_field.dart';
import 'custom_bottom_navigation_bar.dart';
import 'analytics_bottom_bar.dart';
import 'patient_cards.dart';
import 'protocols_list.dart';
import '../view_models/patient_search_viewmodel.dart';

class HomeScreenUI extends StatefulWidget {
  const HomeScreenUI({super.key});

  @override
  State<HomeScreenUI> createState() => _HomeScreenUIState();
}

class _HomeScreenUIState extends State<HomeScreenUI> {
  String _activeTab = 'Картотека';
  final int _analyticsTabIndex = 0;
  final int _mainTabIndex = 0;

  late PatientSearchViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = PatientSearchViewModel();
  }

  void _onTabChanged(String tab) {
    setState(() {
      _activeTab = tab;
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const RemindersStats(),
              TabBarWidget(
                activeTab: _activeTab,
                onTabChanged: _onTabChanged,
              ),
              SearchField(),
              Expanded(
                child: _activeTab == 'Картотека'
                    ? const PatientCards()
                    : const ProtocolsList(),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _activeTab == 'Картотека'
            ? CustomBottomNavigationBar(
          currentIndex: _mainTabIndex,
        )
            : AnalyticsBottomBar(
          currentIndex: _analyticsTabIndex,
        ),
      ),
    );
  }
}