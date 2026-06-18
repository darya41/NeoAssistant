import 'package:flutter/material.dart';
import '../../domain/entities/calculator.dart';
import '../../data/repositories/calculator_repository.dart';

class CalculatorsViewModel extends ChangeNotifier {
  final CalculatorRepository _repository = CalculatorRepository();

  List<Calculator> _calculators = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String? _errorMessage;
  String _searchQuery = '';

  List<Calculator> get calculators => _calculators;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  CalculatorsViewModel() {
    loadCalculators();
  }

  Future<void> loadCalculators() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _calculators = await _repository.getCalculators();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchCalculators(String query) async {
    _searchQuery = query;

    if (query.isEmpty || query.trim().isEmpty) {
      await loadCalculators();
      return;
    }

    _isSearching = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _calculators = await _repository.searchCalculators(query.trim());
      _isSearching = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isSearching = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchQuery = '';
    loadCalculators();
  }

  void retry() {
    if (_searchQuery.isNotEmpty) {
      searchCalculators(_searchQuery);
    } else {
      loadCalculators();
    }
  }
}