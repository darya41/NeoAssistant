import 'package:flutter/material.dart';

import '../../../../models/patient.dart';
import '../../data/repository/patient_repository.dart';

class PatientSearchViewModel extends ChangeNotifier {
  final PatientRepository _repository = PatientRepository();

  List<Patient> _allPatients = [];
  List<Patient> _searchResults = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String? _error;
  String _searchQuery = '';

  String? _selectedGender;
  String? _selectedBloodGroup;
  String? _selectedRhFactor;
  DateTimeRange? _selectedDateRange;

  List<Patient> get displayedPatients {
    final isSearchMode = _searchQuery.isNotEmpty && _searchQuery.length >= 2;
    List<Patient> sourcePatients = isSearchMode ? _searchResults : _allPatients;

    return _applyFilters(sourcePatients);
  }

  List<Patient> _applyFilters(List<Patient> patients) {
    return patients.where((patient) {
      if (_selectedGender != null) {
        String patientGender = '';
        if (patient.gender == 'MALE') {
          patientGender = 'Мужской';
        } else if (patient.gender == 'FEMALE') {
          patientGender = 'Женский';
        } else {
          patientGender = patient.gender;
        }

        if (patientGender != _selectedGender) {
          return false;
        }
      }

      if (_selectedBloodGroup != null &&
          _selectedBloodGroup!.isNotEmpty &&
          patient.bloodGroup != _selectedBloodGroup) {
        return false;
      }

      if (_selectedRhFactor != null &&
          _selectedRhFactor!.isNotEmpty &&
          patient.rhFactor != _selectedRhFactor) {
        return false;
      }

      if (_selectedDateRange != null) {
        if (patient.dateOfBirth.isEmpty) {
          return false;
        }

        final birthDate = DateTime.tryParse(patient.dateOfBirth);
        if (birthDate == null) return false;

        if (birthDate.isBefore(_selectedDateRange!.start) ||
            birthDate.isAfter(_selectedDateRange!.end)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  String? get selectedGender => _selectedGender;
  String? get selectedBloodGroup => _selectedBloodGroup;
  String? get selectedRhFactor => _selectedRhFactor;
  DateTimeRange? get selectedDateRange => _selectedDateRange;

  bool get hasActiveFilters {
    return _selectedGender != null ||
        _selectedBloodGroup != null ||
        _selectedRhFactor != null ||
        _selectedDateRange != null;
  }

  int get activeFiltersCount {
    int count = 0;
    if (_selectedGender != null) count++;
    if (_selectedBloodGroup != null) count++;
    if (_selectedRhFactor != null) count++;
    if (_selectedDateRange != null) count++;
    return count;
  }

  void setGenderFilter(String? gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  void setBloodGroupFilter(String? bloodGroup) {
    _selectedBloodGroup = bloodGroup;
    notifyListeners();
  }

  void setRhFactorFilter(String? rhFactor) {
    _selectedRhFactor = rhFactor;
    notifyListeners();
  }

  void setDateRangeFilter(DateTimeRange? range) {
    _selectedDateRange = range;
    notifyListeners();
  }

  void clearFilters() {
    _selectedGender = null;
    _selectedBloodGroup = null;
    _selectedRhFactor = null;
    _selectedDateRange = null;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  bool get hasResults {
    final isSearchMode = _searchQuery.isNotEmpty && _searchQuery.length >= 2;
    if (isSearchMode) {
      return _applyFilters(_searchResults).isNotEmpty;
    }
    return _applyFilters(_allPatients).isNotEmpty;
  }

  PatientSearchViewModel() {
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allPatients = await _repository.getPatients();
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
      _searchResults = await _repository.searchPatients(query);
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