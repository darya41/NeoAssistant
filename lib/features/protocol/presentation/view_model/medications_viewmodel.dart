import 'package:flutter/material.dart';

import '../../data/repositories/medication_repository.dart';
import '../../domain/entities/medication.dart';

class MedicationsViewModel extends ChangeNotifier {
  final MedicationRepository _repository = MedicationRepository();

  final List<Medication> _medications = [];
  bool _isLoading = false;
  String? _error;

  int _currentPage = 1;
  bool _hasMore = true;
  static const int _pageSize = 20;

  List<Medication> get medications => _medications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentPage => _currentPage;
  bool get hasMore => _hasMore;

  MedicationsViewModel() {
    _loadMedications();
  }

  Future<void> _loadMedications({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _medications.clear();
      _hasMore = true;
    }

    if (!_hasMore && !refresh) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final items = await _repository.getAllMedications(
        page: _currentPage,
        limit: _pageSize,
      );

      if (items.isEmpty || items.length < _pageSize) {
        _hasMore = false;
      }

      _medications.addAll(items);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadNextPage() async {
    if (_isLoading || !_hasMore) return;
    _currentPage++;
    await _loadMedications();
  }

  Future<void> refresh() async {
    await _loadMedications(refresh: true);
  }
}