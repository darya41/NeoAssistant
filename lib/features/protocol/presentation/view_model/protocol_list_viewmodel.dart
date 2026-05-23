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

  static const int _pageSize = 20;

  List<ProtocolListItem> get items => _items;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasNext => _hasNext;
  String? get error => _error;
  bool get hasItems => _items.isNotEmpty;

  ProtocolListViewModel() {
    loadItems();
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
      final result = await _repository.getProtocolListPaginated(
        page: _currentPage,
        limit: _pageSize,
      );

      _items.addAll(result['items']);
      _hasNext = result['hasNext'] ?? false;

      if (result['items'].isNotEmpty) {
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
    await loadItems(refresh: true);
  }

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
}