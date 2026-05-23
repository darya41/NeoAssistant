import 'package:flutter/material.dart';
import '../../data/repositories/medication_repository.dart';
import '../../domain/entities/medication.dart';

class MedicationsViewModel extends ChangeNotifier {
  final MedicationRepository _repository = MedicationRepository();

  final List<Medication> _medications = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String? _error;

  static const int _pageSize = 20;

  List<Medication> get medications => _medications;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get error => _error;

  MedicationsViewModel() {
    loadMedications();
  }

  Future<void> loadMedications({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _medications.clear();
      _hasMore = true;
    }

    if (_currentPage == 1) {
      _isLoading = true;
    } else {
      _isLoadingMore = true;
    }

    _error = null;
    notifyListeners();

    try {
      final result = await _repository.getMedicationsPaginated(
        page: _currentPage,
        limit: _pageSize,
      );

      final newItems = result['items'] as List<Medication>;
      _medications.addAll(newItems);
      _hasMore = result['hasNext'] ?? false;

      if (newItems.isNotEmpty && _hasMore) {
        _currentPage++;
      }

      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadMedications(refresh: true);
  }

  Future<void> loadNextPage() async {
    if (!_isLoadingMore && _hasMore && !_isLoading) {
      await loadMedications();
    }
  }
}