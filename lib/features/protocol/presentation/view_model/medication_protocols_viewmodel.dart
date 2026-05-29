import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/repositories/protocol_repository.dart';
import '../../domain/entities/protocol_list_item.dart';

class MedicationProtocolsViewModel extends ChangeNotifier {
  final ProtocolRepository _repository = ProtocolRepository();

  static const int _pageSize = 20;

  final List<ProtocolListItem> _items = [];
  int _currentPage = 1;
  String? _error;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasNext = true;
  int? _medicationId;

  List<ProtocolListItem> get items => _items;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasNext => _hasNext;
  String? get error => _error;
  bool get hasItems => _items.isNotEmpty;

  void loadProtocolsByMedication(int medicationId) async {
    _medicationId = medicationId;
    _currentPage = 1;
    _items.clear();
    _hasNext = true;
    await _loadProtocols();
  }

  Future<void> _loadProtocols() async {
    if (_currentPage == 1) {
      _isLoading = true;
    } else {
      _isLoadingMore = true;
    }

    _error = null;
    notifyListeners();

    try {
      final result = await _repository.getProtocolsByMedicationPaginated(
        medicationId: _medicationId!,
        page: _currentPage,
        limit: _pageSize,
      );

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

  Future<void> loadNextPage() async {
    if (!_isLoadingMore && _hasNext && !_isLoading) {
      await _loadProtocols();
    }
  }

  Future<void> refresh() async {
    if (_medicationId != null) {
      _currentPage = 1;
      _items.clear();
      _hasNext = true;
      await _loadProtocols();
    }
  }
}