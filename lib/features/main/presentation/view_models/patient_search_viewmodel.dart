import 'package:flutter/material.dart';

import '../../../../models/patient.dart';
import '../../data/repository/patient_service.dart';

class PatientSearchViewModel extends ChangeNotifier {
  List<Patient> _allPatients = [];
  List<Patient> _searchResults = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String? _error;
  String _searchQuery = '';

  List<Patient> get patients {
    if (_searchQuery.isNotEmpty && _searchQuery.length >= 2) {
      return _searchResults;
    }
    return _allPatients;
  }

  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  bool get hasResults {
    if (_searchQuery.isNotEmpty && _searchQuery.length >= 2) {
      return _searchResults.isNotEmpty;
    }
    return _allPatients.isNotEmpty;
  }

  PatientSearchViewModel() {
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allPatients = await PatientService.getPatients();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> search(String query) async {
    _searchQuery = query;

    if (query.isEmpty || query.length < 2) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isSearching = true;
    _error = null;
    notifyListeners();

    try {
      _searchResults = await PatientService.searchPatients(query);
     } catch (e) {
      _error = e.toString();
      _searchResults = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    notifyListeners();
  }

  void refresh() {
    _loadPatients();
  }
}