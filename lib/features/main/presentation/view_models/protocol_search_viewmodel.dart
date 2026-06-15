import 'package:flutter/material.dart';

class ProtocolSearchViewModel extends ChangeNotifier {
  String _activeSearchTab = 'Список';

  static const String _tabList = 'Список';
  static const String _tabMkb = 'МКБ';
  static const String _tabDiagnostics = 'Диагностика';
  static const String _tabMedications = 'Препараты';

  String _protocolSearchQuery = '';
  String _mkbSearchQuery = '';
  String _diagnosticsSearchQuery = '';
  String _medicationsSearchQuery = '';

  bool _isProtocolSearching = false;
  bool _isMkbSearching = false;
  bool _isDiagnosticsSearching = false;
  bool _isMedicationsSearching = false;
  bool _isSearchingActive = false;

  VoidCallback? onSearchCleared;

  String get searchQuery {
    switch (_activeSearchTab) {
      case _tabList:
        return _protocolSearchQuery;
      case _tabMkb:
        return _mkbSearchQuery;
      case _tabDiagnostics:
        return _diagnosticsSearchQuery;
      case _tabMedications:
        return _medicationsSearchQuery;
      default:
        return '';
    }
  }

  bool get isSearching {
    switch (_activeSearchTab) {
      case _tabList:
        return _isProtocolSearching;
      case _tabMkb:
        return _isMkbSearching;
      case _tabDiagnostics:
        return _isDiagnosticsSearching;
      case _tabMedications:
        return _isMedicationsSearching;
      default:
        return false;
    }
  }

  bool get isSearchingActive => _isSearchingActive;

  String get protocolSearchQuery => _protocolSearchQuery;
  String get mkbSearchQuery => _mkbSearchQuery;
  String get diagnosticsSearchQuery => _diagnosticsSearchQuery;
  String get medicationsSearchQuery => _medicationsSearchQuery;

  bool get isProtocolSearching => _isProtocolSearching;
  bool get isMkbSearching => _isMkbSearching;
  bool get isDiagnosticsSearching => _isDiagnosticsSearching;
  bool get isMedicationsSearching => _isMedicationsSearching;

  String get activeSearchTab => _activeSearchTab;

  bool get hasAnySearch =>
      _isProtocolSearching ||
          _isMkbSearching ||
          _isDiagnosticsSearching ||
          _isMedicationsSearching;

  int get searchQueryLength => searchQuery.length;

  void syncActiveTab(String tab) {
    if (_activeSearchTab != tab) {
      _activeSearchTab = tab;
      notifyListeners();
    }
  }

  void setActiveSearchTab(String tab) {
    if (_activeSearchTab != tab) {

      switch (_activeSearchTab) {
        case _tabList:
          _protocolSearchQuery = '';
          _isProtocolSearching = false;
          break;
        case _tabMkb:
          _mkbSearchQuery = '';
          _isMkbSearching = false;
          break;
        case _tabDiagnostics:
          _diagnosticsSearchQuery = '';
          _isDiagnosticsSearching = false;
          break;
        case _tabMedications:
          _medicationsSearchQuery = '';
          _isMedicationsSearching = false;
          break;
      }

      _activeSearchTab = tab;

      onSearchCleared?.call();

      notifyListeners();
    }
  }

  void search(String query) {
    _isSearchingActive = query.isNotEmpty;
    switch (_activeSearchTab) {
      case _tabList:
        searchProtocols(query);
        break;
      case _tabMkb:
        searchMkb(query);
        break;
      case _tabDiagnostics:
        searchDiagnostics(query);
        break;
      case _tabMedications:
        searchMedications(query);
        break;
      default:
    }
  }

  void searchProtocols(String query) {
    _protocolSearchQuery = query;
    _isProtocolSearching = query.isNotEmpty;
    _isSearchingActive = query.isNotEmpty;
    notifyListeners();
  }

  void searchMkb(String query) {
    _mkbSearchQuery = query;
    _isMkbSearching = query.isNotEmpty;
    _isSearchingActive = query.isNotEmpty;
    notifyListeners();
  }

  void searchDiagnostics(String query) {
    _diagnosticsSearchQuery = query;
    _isDiagnosticsSearching = query.isNotEmpty;
    _isSearchingActive = query.isNotEmpty;
    notifyListeners();
  }

  void searchMedications(String query) {
    _medicationsSearchQuery = query;
    _isMedicationsSearching = query.isNotEmpty;
    _isSearchingActive = query.isNotEmpty;
    notifyListeners();
  }

  void clearSearch() {
    switch (_activeSearchTab) {
      case _tabList:
        clearProtocolsSearch();
        break;
      case _tabMkb:
        clearMkbSearch();
        break;
      case _tabDiagnostics:
        clearDiagnosticsSearch();
        break;
      case _tabMedications:
        clearMedicationsSearch();
        break;
    }
    _isSearchingActive = false;
    notifyListeners();
  }

  void clearProtocolsSearch() {
    _protocolSearchQuery = '';
    _isProtocolSearching = false;
    notifyListeners();
  }

  void clearMkbSearch() {
    _mkbSearchQuery = '';
    _isMkbSearching = false;
    notifyListeners();
  }

  void clearDiagnosticsSearch() {
    _diagnosticsSearchQuery = '';
    _isDiagnosticsSearching = false;
    notifyListeners();
  }

  void clearMedicationsSearch() {
    _medicationsSearchQuery = '';
    _isMedicationsSearching = false;
    notifyListeners();
  }

  void clearAllSearches() {
    _protocolSearchQuery = '';
    _mkbSearchQuery = '';
    _diagnosticsSearchQuery = '';
    _medicationsSearchQuery = '';
    _isProtocolSearching = false;
    _isMkbSearching = false;
    _isDiagnosticsSearching = false;
    _isMedicationsSearching = false;
    _isSearchingActive = false;
    notifyListeners();
  }
}