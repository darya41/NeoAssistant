import 'dart:async';

import 'package:flutter/material.dart';
import '../../data/repositories/mkb_repository.dart';
import '../../domain/entities/mkb.dart';

class MkbCategoriesViewModel extends ChangeNotifier {
  final MkbRepository _repository = MkbRepository();

  static const _debounceDuration = Duration(milliseconds: 500);

  List<MkbCategory> _mkbCategories = [];
  List<MkbCategory> _selectedPath = [];
  MkbCategory? _currentParent;
  String _searchQuery = '';
  String? _error;
  bool _isLoading = false;
  Timer? _debounceTimer;

  List<MkbCategory> get mkbCategories => _mkbCategories;
  List<MkbCategory> get selectedPath => _selectedPath;
  MkbCategory? get currentParent => _currentParent;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get canGoBack => _selectedPath.isNotEmpty;
  String get currentSearchQuery => _searchQuery;
  bool get isSearching => _searchQuery.isNotEmpty;
  bool get hasNoData => _mkbCategories.isEmpty && !isSearching;

  MkbCategoriesViewModel() {
    _loadRootLevel();
  }

  void updateSearchQuery(String newQuery) {
    if (_searchQuery == newQuery) return;

    _searchQuery = newQuery;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, _performSearch);
  }

  Future<void> selectSearchResult(MkbCategory result) async {
    await _executeOperation(() async {
      final path = await _repository.getMkbPath(result.code);
      _selectedPath = path;
      _currentParent = result;
      _mkbCategories = await _repository.getMkbByParentCode(result.code);
      _searchQuery = '';
    });
  }

  Future<void> loadChildren(MkbCategory parent) async {
    await _executeOperation(() async {
      final children = await _repository.getMkbByParentCode(parent.code);
      if (children.isNotEmpty) {
        _mkbCategories = children;
        _currentParent = parent;
        _selectedPath.add(parent);
        _searchQuery = '';
      }
    });
  }

  Future<void> goBack() async {
    if (_searchQuery.isNotEmpty) {
      await _performSearch();
      return;
    }

    if (_selectedPath.isEmpty) {
      await _loadRootLevel();
      return;
    }

    await _executeOperation(() async {
      _selectedPath.removeLast();

      if (_selectedPath.isEmpty) {
        await _loadRootLevel();
      } else {
        final lastParent = _selectedPath.last;
        _mkbCategories = await _repository.getMkbByParentCode(lastParent.code);
        _currentParent = lastParent;
      }
    });
  }

  Future<void> navigateToLevel(MkbCategory category) async {
    await _executeOperation(() async {
      final index = _selectedPath.indexWhere((item) => item.code == category.code);
      if (index != -1) {
        _selectedPath = _selectedPath.sublist(0, index + 1);
        _mkbCategories = await _repository.getMkbByParentCode(category.code);
        _currentParent = category;
        _searchQuery = '';
      }
    });
  }

  Future<void> goToRoot() async {
    await _loadRootLevel();
  }

  Future<void> refresh() async {
    if (_searchQuery.isNotEmpty) {
      await _performSearch();
    } else if (_selectedPath.isEmpty) {
      await _loadRootLevel();
    } else {
      final lastParent = _selectedPath.last;
      _mkbCategories = await _repository.getMkbByParentCode(lastParent.code);
      _currentParent = lastParent;
      notifyListeners();
    }
  }

  Future<void> _performSearch() async {
    if (_searchQuery.isEmpty) {
      await _refreshCurrentLevel();
      return;
    }

    await _executeOperation(() async {
      final results = await _repository.searchMkb(_searchQuery);
      _mkbCategories = results;
    }, showLoading: true);
  }

  Future<void> _refreshCurrentLevel() async {
    if (_selectedPath.isEmpty) {
      await _loadRootLevel();
    } else {
      final lastParent = _selectedPath.last;
      _mkbCategories = await _repository.getMkbByParentCode(lastParent.code);
      _currentParent = lastParent;
      notifyListeners();
    }
  }

  Future<void> _loadRootLevel() async {
    await _executeOperation(() async {
      _mkbCategories = await _repository.getMkbByLevel(1);
      _currentParent = null;
      _selectedPath.clear();
      _searchQuery = '';
    });
  }

  Future<void> _executeOperation(
      Future<void> Function() operation, {
        bool showLoading = true,
      }) async {
    if (showLoading) {
      _isLoading = true;
    }
    _error = null;
    notifyListeners();

    try {
      await operation();
    } catch (e) {
      _error = e.toString();
    } finally {
      if (showLoading) {
        _isLoading = false;
      }
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}