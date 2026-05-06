import 'package:flutter/material.dart';

import '../../data/repositories/diagnostic_repository.dart';
import '../../domain/entities/diagnostic_test.dart';

class DiagnosticsViewModel extends ChangeNotifier {
  final DiagnosticRepository _repository = DiagnosticRepository();

  List<DiagnosticTest> _diagnostics = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  int _currentPage = 1;
  final int _totalPages = 1;
  bool _hasMore = true;
  static const int _pageSize = 20;

  List<DiagnosticTest> get diagnostics => _diagnostics;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get hasMore => _hasMore;
  bool get isSearching => _searchQuery.isNotEmpty;

  DiagnosticsViewModel() {
    _loadDiagnostics();
  }

  Future<void> _loadDiagnostics({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _diagnostics.clear();
      _hasMore = true;
    }

    if (!_hasMore && !refresh) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final items = await _repository.getAllDiagnostics(
        page: _currentPage,
        limit: _pageSize,
      );

      if (items.isEmpty || items.length < _pageSize) {
        _hasMore = false;
      }

      _diagnostics.addAll(items);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadNextPage() async {
    if (_isLoading || !_hasMore || isSearching) return;
    _currentPage++;
    await _loadDiagnostics();
  }

  Future<void> refresh() async {
    await _loadDiagnostics(refresh: true);
  }

  Future<void> searchDiagnostics(String query) async {
    _searchQuery = query;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (query.isEmpty) {
        _currentPage = 1;
        _diagnostics.clear();
        _hasMore = true;
        await _loadDiagnostics();
      } else {
        final results = await _repository.searchDiagnostics(query);
        _diagnostics = results;
        _hasMore = false;
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
    if (_searchQuery.isNotEmpty) {
      _searchQuery = '';
      refresh();
    }
  }
}