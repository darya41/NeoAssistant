import 'package:flutter/material.dart';

import '../../data/repositories/protocol_repository.dart';
import '../../domain/entities/medication.dart';
import '../../domain/entities/mkb.dart';
import '../../domain/entities/protocol.dart';

class ProtocolSearchViewModel extends ChangeNotifier {
  final ProtocolRepository _repository = ProtocolRepository();

  String _activeTab = 'Список';

  List<Protocol> _allProtocols = [];
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
  bool get isMkbTab => _activeTab == 'Категории МКБ';
  bool get isMedicationsTab => _activeTab == 'Препараты';

  void switchToListTab() {
    if (_activeTab != 'Список') {
      _activeTab = 'Список';
      _searchQuery = '';
      notifyListeners();
    }
  }

  void switchToMkbTab() {
    if (_activeTab != 'Категории МКБ') {
      _activeTab = 'Категории МКБ';
      notifyListeners();
    }
  }

  void switchToMedicationsTab() {
    if (_activeTab != 'Препараты') {
      _activeTab = 'Препараты';
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

  ProtocolSearchViewModel() {
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.wait([
        _loadProtocols(),
      ]);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadProtocols() async {
    _allProtocols = await _repository.getAllProtocols();
    _filteredProtocols = _allProtocols;
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
        _filteredProtocols = await _repository.searchProtocols(query);
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

  Future<void> filterByMkbCode(String code) async {
  }

  Future<void> filterByMedication(int medicationId) async {
  }

  Future<void> refresh() async {
    await _loadAllData();
    _searchQuery = '';
    notifyListeners();
  }
}