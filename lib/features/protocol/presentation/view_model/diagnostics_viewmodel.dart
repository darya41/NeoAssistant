import 'package:flutter/material.dart';
import '../../data/repositories/diagnostic_repository.dart';
import '../../domain/entities/diagnostic_test.dart';

class DiagnosticsViewModel extends ChangeNotifier {
  final DiagnosticRepository _repository = DiagnosticRepository();

  List<DiagnosticTest> _diagnostics = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String? _error;

  static const int _pageSize = 20;

  List<DiagnosticTest> get diagnostics => _diagnostics;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get error => _error;

  DiagnosticsViewModel() {
    loadDiagnostics();
  }

  Future<void> loadDiagnostics({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _diagnostics.clear();
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
      final result = await _repository.getDiagnosticsPaginated(
        page: _currentPage,
        limit: _pageSize,
      );

      final newItems = result['items'] as List<DiagnosticTest>;
      _diagnostics.addAll(newItems);
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
    await loadDiagnostics(refresh: true);
  }

  Future<void> loadNextPage() async {
    if (!_isLoadingMore && _hasMore && !_isLoading) {
      await loadDiagnostics();
    }
  }
}