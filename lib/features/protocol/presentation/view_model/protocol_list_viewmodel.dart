import 'dart:async';

import 'package:flutter/material.dart';
import '../../data/repositories/protocol_repository.dart';
import '../../domain/entities/protocol_list_item.dart';

class ProtocolListViewModel extends ChangeNotifier {
  final ProtocolRepository _repository = ProtocolRepository();

  final List<ProtocolListItem> _items = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasNext = true;
  int _currentPage = 1;
  String? _error;
  String _searchQuery = '';
  Timer? _debounceTimer;
  final int? techLevelId;

  static const int _pageSize = 20;
  static const _debounceDuration = Duration(milliseconds: 500);

  List<ProtocolListItem> get items => _items;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasNext => _hasNext;
  String? get error => _error;
  bool get hasItems => _items.isNotEmpty;
  String get currentSearchQuery => _searchQuery;
  bool get isSearching => _searchQuery.isNotEmpty;

  ProtocolListViewModel({this.techLevelId}) {
    loadItems();
  }
  void updateSearchQuery(String newQuery) {
    if (_searchQuery == newQuery) return;

    _searchQuery = newQuery;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, () {
      _resetAndSearch();
    });
  }

  void _resetAndSearch() {
    _currentPage = 1;
    _items.clear();
    _hasNext = true;
    loadItems(refresh: true);
  }

  Future<void> loadItems({bool refresh = false}) async {
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
    notifyListeners();

    try {
      Map<String, dynamic> result;

      if (_searchQuery.isNotEmpty) {
        result = await _repository.searchProtocolsPaginated(
          query: _searchQuery,
          page: _currentPage,
          limit: _pageSize,
          techLevelId: techLevelId,
        );
      } else {
        result = await _repository.getProtocolListPaginated(
          page: _currentPage,
          limit: _pageSize,
          techLevelId: techLevelId,
        );
      }

      _items.addAll(result['items']);
      _hasNext = result['hasNext'] ?? false;

      if (result['items'].isNotEmpty && _hasNext) {
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

  Future<void> refresh() => loadItems(refresh: true);

  Future<void> loadNextPage() async {
    if (!_isLoadingMore && _hasNext && !_isLoading) {
      await loadItems();
    }
  }

  ProtocolListItem? getItemById(int id) {
    try {
      return _items.firstWhere((item) => item.hierarchyId == id);
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}