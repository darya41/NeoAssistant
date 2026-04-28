import 'package:flutter/material.dart';

import '../../../../models/patient.dart';
import '../../data/repositories/patient_repository.dart';

class PatientSearchViewModel extends ChangeNotifier {
  final PatientRepository _repository = PatientRepository();

  List<Patient> _allPatients = [];
  List<Patient> _searchResults = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String? _error;
  String _searchQuery = '';

  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  int _searchPage = 1;
  bool _searchHasMore = true;
  bool _isSearchingMore = false;

  static const int _pageSize = 10;

  String? _selectedGender;
  String? _selectedBloodGroup;
  String? _selectedRhFactor;
  DateTimeRange? _selectedDateRange;

  List<Patient> get displayedPatients {
    final isSearchMode = _searchQuery.isNotEmpty;
    List<Patient> sourcePatients = isSearchMode ? _searchResults : _allPatients;
    return _applyFilters(sourcePatients);
  }

  bool get hasMore => _searchQuery.isNotEmpty ? _searchHasMore : _hasMore;
  bool get isLoadingMore => _searchQuery.isNotEmpty ? _isSearchingMore : _isLoadingMore;
  int get currentPage => _searchQuery.isNotEmpty ? _searchPage : _currentPage;

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
    if (_searchQuery.isNotEmpty) {
      _performSearch(reset: true);
    }
    notifyListeners();
  }

  void setBloodGroupFilter(String? bloodGroup) {
    _selectedBloodGroup = bloodGroup;
    if (_searchQuery.isNotEmpty) {
      _performSearch(reset: true);
    }
    notifyListeners();
  }

  void setRhFactorFilter(String? rhFactor) {
    _selectedRhFactor = rhFactor;
    if (_searchQuery.isNotEmpty) {
      _performSearch(reset: true);
    }
    notifyListeners();
  }

  void setDateRangeFilter(DateTimeRange? range) {
    _selectedDateRange = range;
    if (_searchQuery.isNotEmpty) {
      _performSearch(reset: true);
    }
    notifyListeners();
  }

  void clearFilters() {
    _selectedGender = null;
    _selectedBloodGroup = null;
    _selectedRhFactor = null;
    _selectedDateRange = null;
    if (_searchQuery.isNotEmpty) {
      _performSearch(reset: true);
    } else {
      refresh();
    }
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  bool get hasResults {
    final isSearchMode = _searchQuery.isNotEmpty;
    if (isSearchMode) {
      return _applyFilters(_searchResults).isNotEmpty;
    }
    return _applyFilters(_allPatients).isNotEmpty;
  }

  PatientSearchViewModel() {
    _loadPatients();
  }

  Future<void> _loadPatients({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _allPatients.clear();
      _hasMore = true;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.getPatients(page: _currentPage, limit: _pageSize);
      final List<Patient> newPatients = result['patients'];

      if (refresh) {
        _allPatients = newPatients;
      } else {
        _allPatients.addAll(newPatients);
      }

      _hasMore = result['hasNext'] ?? false;
      _currentPage = result['currentPage'] ?? _currentPage;

    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadMoreRegularPatients() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final result = await _repository.getPatients(page: nextPage, limit: _pageSize);
      final List<Patient> newPatients = result['patients'];

      if (newPatients.isNotEmpty) {
        _allPatients.addAll(newPatients);
        _currentPage = result['currentPage'] ?? nextPage;
        _hasMore = result['hasNext'] ?? false;
      } else {
        _hasMore = false;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> _performSearch({bool reset = true}) async {
    if (_searchQuery.isEmpty) return;

    if (reset) {
      _searchPage = 1;
      _searchResults.clear();
      _searchHasMore = true;
      _isSearching = true;
    } else {
      _isSearchingMore = true;
    }

    _error = null;
    notifyListeners();

    try {
      final result = await _repository.searchPatients(
        query: _searchQuery,
        page: reset ? _searchPage : _searchPage + 1,
        limit: _pageSize,
        gender: _selectedGender,
        bloodGroup: _selectedBloodGroup,
        rhFactor: _selectedRhFactor,
        dateFrom: _selectedDateRange?.start.toIso8601String().split('T')[0],
        dateTo: _selectedDateRange?.end.toIso8601String().split('T')[0],
      );

      final List<Patient> newPatients = result['patients'];

      if (reset) {
        _searchResults = newPatients;
        _searchPage = result['currentPage'] ?? 1;
      } else {
        _searchResults.addAll(newPatients);
        _searchPage = result['currentPage'] ?? _searchPage + 1;
      }

      _searchHasMore = result['hasNext'] ?? false;

    } catch (e) {
      _error = e.toString();
      if (reset) {
        _searchResults = [];
      }
    } finally {
      if (reset) {
        _isSearching = false;
      } else {
        _isSearchingMore = false;
      }
      notifyListeners();
    }
  }

  Future<void> _loadMoreSearchResults() async {
    if (_isSearchingMore || !_searchHasMore) return;
    await _performSearch(reset: false);
  }

  Future<void> loadMorePatients() async {
    if (_searchQuery.isNotEmpty) {
      await _loadMoreSearchResults();
    } else {
      await _loadMoreRegularPatients();
    }
  }

  Future<void> search(String query) async {
    _searchQuery = query;

    if (query.isEmpty) {
      _searchResults = [];
      _searchHasMore = true;
      _searchPage = 1;
      await _loadPatients(refresh: true);
      return;
    }

    await _performSearch(reset: true);
  }

  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    _searchHasMore = true;
    _searchPage = 1;
    _hasMore = true;
    _currentPage = 1;
    _loadPatients(refresh: true);
  }

  void refresh() {
    if (_searchQuery.isNotEmpty) {
      _performSearch(reset: true);
    } else {
      _currentPage = 1;
      _hasMore = true;
      _loadPatients(refresh: true);
    }
  }
}