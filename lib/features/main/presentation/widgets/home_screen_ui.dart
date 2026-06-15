import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/storage/token_storage.dart';
import '../view_models/protocol_search_viewmodel.dart';
import 'reminders_stats.dart';
import 'tab_bar_widget.dart';
import 'search_field.dart';
import 'navigation/custom_bottom_navigation_bar.dart';
import 'navigation/analytics_bottom_bar.dart';
import 'patient_cards.dart';
import '../../../protocol/presentation/widget/protocols_tab_container.dart';
import '../view_models/patient_search_viewmodel.dart';
import '../view_models/home_viewmodel.dart';

class HomeScreenUI extends StatefulWidget {
  final bool isGuest;
  final String? initialTab;

  const HomeScreenUI({
    super.key,
    this.isGuest = false,
    this.initialTab,
  });

  @override
  State<HomeScreenUI> createState() => _HomeScreenUIState();
}

class _HomeScreenUIState extends State<HomeScreenUI> {
  late final HomeViewModel _homeViewModel;
  late final PatientSearchViewModel _patientSearchViewModel;
  late final ProtocolSearchViewModel _protocolSearchViewModel;
  bool _isInitialized = false;
  int? _currentUserTechLevelId;

  final GlobalKey<SearchFieldState> _searchFieldKey = GlobalKey<SearchFieldState>();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;

    _homeViewModel = HomeViewModel();
    _protocolSearchViewModel = ProtocolSearchViewModel();
    _patientSearchViewModel = PatientSearchViewModel();

    _protocolSearchViewModel.onSearchCleared = () {
      _searchFieldKey.currentState?.clearTextField();
    };

    if (widget.initialTab != null) {
      if (widget.initialTab == 'Аналитика') {
        _homeViewModel.switchToAnalytics();
      } else if (widget.initialTab == 'Картотека') {
        _homeViewModel.switchToCardioeka();
      }
    } else if (widget.isGuest) {
      _homeViewModel.switchToAnalytics();
    }

    if (!widget.isGuest) {
      _currentUserTechLevelId = await TokenStorage.getTechLevelId();
    }

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _homeViewModel.dispose();
    _patientSearchViewModel.dispose();
    _protocolSearchViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _homeViewModel),
        ChangeNotifierProvider.value(value: _patientSearchViewModel),
        ChangeNotifierProvider.value(value: _protocolSearchViewModel),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                if (!widget.isGuest)
                  const SizedBox(
                    height: 125,
                    child: RemindersStats(),
                  ),
                TabBarWidget(
                  activeTab: _homeViewModel.activeTab,
                  onTabChanged: _homeViewModel.onTabChanged,
                  isGuest: widget.isGuest,
                ),
                SearchField(
                  key: _searchFieldKey,
                  isGuest: widget.isGuest,
                  protocolSearchViewModel: _protocolSearchViewModel,
                ),
                SizedBox(
                  height: 600,
                  child: Consumer<HomeViewModel>(
                    builder: (context, viewModel, child) {
                      if (widget.isGuest || !viewModel.isCardioeka) {
                        return ProtocolsTabContainer(
                          protocolSearchViewModel: _protocolSearchViewModel,
                          techLevelId: _currentUserTechLevelId,
                        );
                      }
                      return const PatientCards();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            if (widget.isGuest || !viewModel.isCardioeka) {
              return AnalyticsBottomBar(
                currentIndex: viewModel.analyticsTabIndex,
                isGuest: widget.isGuest,
              );
            }
            return CustomBottomNavigationBar(
              currentIndex: viewModel.mainTabIndex,
            );
          },
        ),
      ),
    );
  }
}