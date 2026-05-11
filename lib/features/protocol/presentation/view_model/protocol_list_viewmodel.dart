import 'package:flutter/material.dart';
import '../../data/repositories/protocol_repository.dart';
import '../../domain/entities/protocol_list_item.dart';

class ProtocolListViewModel extends ChangeNotifier {
  final ProtocolRepository _repository = ProtocolRepository();

  List<ProtocolListItem> _items = [];
  List<ProtocolListItem> _filteredItems = [];
  bool _isLoading = false;
  String? _error;

  List<ProtocolListItem> get items => _filteredItems;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasItems => _filteredItems.isNotEmpty;

  ProtocolListViewModel() {
    loadItems();
  }

  Future<void> loadItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _repository.getProtocolFlatList();
      _filteredItems = _items;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadItems();
  }

  ProtocolListItem? getItemById(int id) {
    try {
      return _items.firstWhere((item) => item.hierarchyId == id);
    } catch (e) {
      return null;
    }
  }
}