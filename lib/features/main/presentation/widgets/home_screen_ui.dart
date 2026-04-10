import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/protocol_search_viewmodel.dart';
import 'reminders_stats.dart';
import 'tab_bar_widget.dart';
import 'search_field.dart';
import 'navigation/custom_bottom_navigation_bar.dart';
import 'navigation/analytics_bottom_bar.dart';
import 'patient_cards.dart';
import 'protocols_list.dart';
import '../view_models/patient_search_viewmodel.dart';
import '../view_models/home_viewmodel.dart';


class HomeScreenUI extends StatefulWidget {
  const HomeScreenUI({super.key});

  @override
  State<HomeScreenUI> createState() => _HomeScreenUIState();
}

class _HomeScreenUIState extends State<HomeScreenUI> {
  late final HomeViewModel _homeViewModel;
  late final PatientSearchViewModel _patientSearchViewModel;
  late final ProtocolSearchViewModel _protocolSearchViewModel;

  @override
  void initState() {
    super.initState();
    _homeViewModel = HomeViewModel();
    _patientSearchViewModel = PatientSearchViewModel();
    _protocolSearchViewModel = ProtocolSearchViewModel();
  }

  @override
  void dispose() {
    _homeViewModel.dispose();
    _patientSearchViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _homeViewModel),
        ChangeNotifierProvider.value(value: _patientSearchViewModel),
        ChangeNotifierProvider.value(value: _protocolSearchViewModel),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const RemindersStats(),
              Consumer<HomeViewModel>(
                builder: (context, viewModel, child) {
                  return TabBarWidget(
                    activeTab: viewModel.activeTab,
                    onTabChanged: viewModel.onTabChanged,
                  );
                },
              ),
              SearchField(),
              Expanded(
                child: Consumer<HomeViewModel>(
                  builder: (context, viewModel, child) {
                    return viewModel.isCardioeka
                        ? const PatientCards()
                        : const ProtocolsList();
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            return viewModel.isCardioeka
                ? CustomBottomNavigationBar(
              currentIndex: viewModel.mainTabIndex,
            )
                : AnalyticsBottomBar(
              currentIndex: viewModel.analyticsTabIndex,
            );
          },
        ),
      ),
    );
  }
}