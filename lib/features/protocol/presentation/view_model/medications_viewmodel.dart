import 'package:flutter/material.dart';
import '../../data/repositories/medication_repository.dart';
import '../../domain/entities/medication.dart';

class MedicationsViewModel extends ChangeNotifier {
  final MedicationRepository _repository = MedicationRepository();

  String _searchQuery;
  String? _selectedDrugClass;

  List<Medication> _items = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasNext = true;
  int _currentPage = 1;
  String? _error;

  bool _isDisposed = false;

  static const int _pageSize = 20;

  List<Medication> get items => _items;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasNext => _hasNext;
  String? get error => _error;
  String get currentSearchQuery => _searchQuery;
  String? get selectedDrugClass => _selectedDrugClass;

  MedicationsViewModel({
    required String searchQuery,
    String? drugClass,
  }) : _searchQuery = searchQuery {
    _selectedDrugClass = drugClass;
    _loadInitialData();
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed) {
        loadItems();
      }
    });
  }

  void updateSearchQuery(String newQuery) {
    if (_isDisposed) return;
    if (_searchQuery != newQuery) {
      _searchQuery = newQuery;
      _resetAndReload();
    }
  }

  void updateDrugClass(String? newDrugClass) {
    if (_isDisposed) return;
    if (_selectedDrugClass != newDrugClass) {
      _selectedDrugClass = newDrugClass;
      _resetAndReload();
    }
  }

  void _resetAndReload() {
    _currentPage = 1;
    _items.clear();
    _hasNext = true;
    _error = null;
    loadItems(refresh: true);
  }

  Future<void> loadItems({bool refresh = false}) async {
    if (_isDisposed) return;

    if (refresh) {
      _currentPage = 1;
      _items.clear();
      _hasNext = true;
    }

    if (_currentPage == 1) {
      _isLoading = true;
    } else {
      _isLoadingMore = true;
    }

    _error = null;

    if (!_isDisposed) {
      notifyListeners();
    }

    try {
      Map<String, dynamic> result;

      if (_searchQuery.isNotEmpty) {
        result = await _repository.searchMedicationsPaginated(
          query: _searchQuery,
          page: _currentPage,
          limit: _pageSize,
        );
      } else if (_selectedDrugClass != null && _selectedDrugClass!.isNotEmpty) {
        result = await _repository.getMedicationsByDrugClassPaginated(
          drugClass: _selectedDrugClass!,
          page: _currentPage,
          limit: _pageSize,
        );
      } else {
        result = await _repository.getMedicationsPaginated(
          page: _currentPage,
          limit: _pageSize,
        );
      }

      if (_isDisposed) return;

      final newItems = result['items'] as List<Medication>;

      if (refresh || _currentPage == 1) {
        _items = newItems;
      } else {
        _items.addAll(newItems);
      }

      _hasNext = result['hasNext'] ?? false;

      if (newItems.isNotEmpty && _hasNext) {
        _currentPage++;
      }

      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      if (_isDisposed) return;
      _error = e.toString();
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    if (_isDisposed) return;
    await loadItems(refresh: true);
  }

  Future<void> loadNextPage() async {
    if (_isDisposed) return;
    if (!_isLoadingMore && _hasNext && !_isLoading) {
      await loadItems();
    }
  }

  void filterByDrugClass(String? drugClass) {
    if (_isDisposed) return;
    updateDrugClass(drugClass);
  }

  @override
  void dispose() {
    _isDisposed = true;
    _items.clear();
    super.dispose();
  }
}