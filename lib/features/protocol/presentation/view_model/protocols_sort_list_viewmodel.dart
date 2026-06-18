import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/repositories/protocol_repository.dart';
import '../../domain/entities/protocol_list_item.dart';

class ProtocolsSortListViewmodel extends ChangeNotifier {
  final ProtocolRepository _repository = ProtocolRepository();

  static const int _pageSize = 20;

  final List<ProtocolListItem> _items = [];

  int? _sourceId;
  String? _sourceType;
  int _currentPage = 1;
  String? _error;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasNext = true;
  final int? techLevelId;

  List<ProtocolListItem> get items => _items;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasNext => _hasNext;
  String? get error => _error;
  bool get hasItems => _items.isNotEmpty;
  bool get isFirstPage => _currentPage == 1;

  ProtocolsSortListViewmodel({this.techLevelId});

  void loadProtocolsByMedication(int medicationId) {
    _sourceId = medicationId;
    _sourceType = 'medication';
    _resetAndLoad();
  }

  void loadProtocolsByDiagnostic(int diagnosticId) {
    _sourceId = diagnosticId;
    _sourceType = 'diagnostic';
    _resetAndLoad();
  }

  void loadProtocolsByMkb(int mkbId) {
    _sourceId = mkbId;
    _sourceType = 'mkb';
    _resetAndLoad();
  }

  Future<void> refresh() async {
    if (_sourceId != null && _sourceType != null) {
      await _resetAndLoad();
    }
  }

  Future<void> loadNextPage() async {
    final canLoadMore = !_isLoadingMore && _hasNext && !_isLoading;
    if (canLoadMore) {
      await _loadProtocols();
    }
  }

  Future<void> _resetAndLoad() async {
    _currentPage = 1;
    _items.clear();
    _hasNext = true;
    await _loadProtocols();
  }

  Future<void> _loadProtocols() async {
    _setLoadingState();
    _error = null;
    notifyListeners();

    try {
      final result = await _fetchData();
      _processResult(result);
      _updatePaginationState(result['items']);
    } catch (e) {
      _error = e.toString();
      debugPrint('[ProtocolsSortListViewmodel] Error: $_error');
    } finally {
      _finishLoading();
    }
  }

  void _setLoadingState() {
    if (isFirstPage) {
      _isLoading = true;
    } else {
      _isLoadingMore = true;
    }
  }

  Future<Map<String, dynamic>> _fetchData() async {
    if (_sourceType == 'medication') {
      return await _repository.getProtocolsByMedicationPaginated(
        medicationId: _sourceId!,
        page: _currentPage,
        limit: _pageSize,
        techLevelId: techLevelId,
      );
    } else if (_sourceType == 'diagnostic') {
      return await _repository.getProtocolsByDiagnosticPaginated(
        diagnosticId: _sourceId!,
        page: _currentPage,
        limit: _pageSize,
        techLevelId: techLevelId,
      );
    } else {
      return await _repository.getProtocolsByMkbPaginated(
        mkbId: _sourceId!,
        page: _currentPage,
        limit: _pageSize,
        techLevelId: techLevelId,
      );
    }
  }

  void _processResult(Map<String, dynamic> result) {
    _items.addAll(result['items']);
    _hasNext = result['hasNext'] ?? false;
  }

  void _updatePaginationState(List items) {
    if (items.isNotEmpty && _hasNext) {
      _currentPage++;
    }
  }

  void _finishLoading() {
    _isLoading = false;
    _isLoadingMore = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _items.clear();
    super.dispose();
  }
}