import 'package:flutter/material.dart';

class ProtocolTabViewModel extends ChangeNotifier {
  String _activeTab = 'Список';

  String get activeTab => _activeTab;
  bool get isListTab => _activeTab == 'Список';
  bool get isMkbTab => _activeTab == 'МКБ';
  bool get isDiagnosticsTab => _activeTab == 'Диагностика';
  bool get isMedicationsTab => _activeTab == 'Препараты';

  void switchToListTab() {
    if (_activeTab != 'Список') {
      _activeTab = 'Список';
      notifyListeners();
    }
  }

  void switchToMkbTab() {
    if (_activeTab != 'МКБ') {
      _activeTab = 'МКБ';
      notifyListeners();
    }
  }

  void switchToDiagnosticsTab() {
    if (_activeTab != 'Диагностика') {
      _activeTab = 'Диагностика';
      notifyListeners();
    }
  }

  void switchToMedicationsTab() {
    if (_activeTab != 'Препараты') {
      _activeTab = 'Препараты';
      notifyListeners();
    }
  }
}