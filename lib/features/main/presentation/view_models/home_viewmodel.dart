import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  String _activeTab = 'Картотека';
  final int _analyticsTabIndex = 0;
  final int _mainTabIndex = 0;

  String get activeTab => _activeTab;
  int get analyticsTabIndex => _analyticsTabIndex;
  int get mainTabIndex => _mainTabIndex;

  bool get isCardioeka => _activeTab == 'Картотека';
  bool get isAnalytics => _activeTab != 'Картотека';

  void onTabChanged(String tab) {
    if (_activeTab != tab) {
      _activeTab = tab;
      notifyListeners();
    }
  }

  void switchToCardioeka() {
    if (_activeTab != 'Картотека') {
      _activeTab = 'Картотека';
      notifyListeners();
    }
  }

  void switchToAnalytics() {
    if (_activeTab != 'Аналитика') {
      _activeTab = 'Аналитика';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}