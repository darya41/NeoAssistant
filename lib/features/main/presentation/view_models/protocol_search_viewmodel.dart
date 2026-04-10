import 'package:flutter/material.dart';

import '../../../protocol/data/repositories/protocol_repository.dart';
import '../../../protocol/domain/entities/protocol.dart';

class ProtocolSearchViewModel extends ChangeNotifier {
  final ProtocolRepository _repository = ProtocolRepository();

  List<Protocol> _allProtocols = [];
  List<Protocol> _filteredProtocols = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String? _error;

  List<Protocol> get filteredProtocols => _filteredProtocols;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String? get error => _error;

  ProtocolSearchViewModel() {
    _loadAllProtocols();
  }

  Future<void> _loadAllProtocols() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allProtocols = await _repository.getAllProtocols();
      _filteredProtocols = _allProtocols;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchProtocols(String query) async {
    _searchQuery = query;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _filteredProtocols = await _repository.searchProtocols(query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredProtocols = _allProtocols;
    notifyListeners();
  }

  Future<void> refresh() async {
    await _loadAllProtocols();
    _searchQuery = '';
    notifyListeners();
  }
}