import 'package:flutter/material.dart';

import '../../domain/entities/medication.dart';
import '../../domain/entities/mkb.dart';
import '../../domain/entities/protocol.dart';

class ProtocolSearchViewModel extends ChangeNotifier {

  String _activeTab = 'Список';

  final List<Protocol> _allProtocols = [];
  List<Protocol> _filteredProtocols = [];
  String _searchQuery = '';

  final List<MkbCategory> _mkbCategories = [];
  final List<Medication> _medications = [];

  bool _isLoading = false;
  String? _error;

  String get activeTab => _activeTab;
  List<Protocol> get filteredProtocols => _filteredProtocols;
  List<MkbCategory> get mkbCategories => _mkbCategories;
  List<Medication> get medications => _medications;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool get isListTab => _activeTab == 'Список';
  bool get isMkbTab => _activeTab == 'МКБ';
  bool get isMedicationsTab => _activeTab == 'Препараты';
  bool get isDiagnosticsTab => _activeTab == 'Диагностика';

  void switchToListTab() {
    if (_activeTab != 'Список') {
      _activeTab = 'Список';
      _searchQuery = '';
      notifyListeners();
    }
  }

  void switchToMkbTab() {
    if (_activeTab != 'МКБ') {
      _activeTab = 'МКБ';
      notifyListeners();
    }
  }

  void switchToMedicationsTab() {
    if (_activeTab != 'Препараты') {
      _activeTab = 'Препараты';
      notifyListeners();
    }
  }

  void switchToDiagnosticsTab() {
    if (_activeTab != 'Диагностика') {
      _activeTab = 'Диагностика';
      notifyListeners();
    }
  }

  void onTabChanged(String tab) {
    if (_activeTab != tab) {
      _activeTab = tab;
      if (tab == 'Список') {
        _searchQuery = '';
      }
      notifyListeners();
    }
  }

  Future<void> searchProtocols(String query) async {
    _searchQuery = query;

    if (_activeTab != 'Список') {
      _activeTab = 'Список';
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (query.isEmpty) {
        _filteredProtocols = _allProtocols;
      } else {
        //_filteredProtocols = await _repository.searchProtocols(query);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredProtocols = _allProtocols;
    notifyListeners();
  }

  Future<void> refresh() async {
    _searchQuery = '';
    notifyListeners();
  }
}