import 'package:flutter/material.dart';

import '../../data/repositories/mkb_repository.dart';
import '../../domain/entities/mkb.dart';

class MkbCategoriesViewModel extends ChangeNotifier {
  final MkbRepository _repository = MkbRepository();

  List<MkbCategory> _mkbCategories = [];
  List<MkbCategory> _selectedPath = [];
  MkbCategory? _currentParent;
  bool _isLoading = false;
  String? _error;

  List<MkbCategory> get mkbCategories => _mkbCategories;
  List<MkbCategory> get selectedPath => _selectedPath;
  MkbCategory? get currentParent => _currentParent;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get canGoBack => _selectedPath.isNotEmpty;

  MkbCategoriesViewModel() {
    _loadRootLevel();
  }

  Future<void> _loadRootLevel() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _mkbCategories = await _repository.getMkbByLevel(1);
      _currentParent = null;
      _selectedPath.clear();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadChildren(MkbCategory parent) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final children = await _repository.getMkbByParentCode(parent.code);

      if (children.isNotEmpty) {
        _mkbCategories = children;
        _currentParent = parent;
        _selectedPath.add(parent);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> goBack() async {
    if (_selectedPath.isEmpty) {
      await _loadRootLevel();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _selectedPath.removeLast();

      if (_selectedPath.isEmpty) {
        await _loadRootLevel();
      } else {
        final lastParent = _selectedPath.last;
        final children = await _repository.getMkbByParentCode(lastParent.code);
        _mkbCategories = children;
        _currentParent = lastParent;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> goToRoot() async {
    await _loadRootLevel();
  }

  Future<void> refresh() async {
    if (_selectedPath.isEmpty) {
      await _loadRootLevel();
    } else {
      final lastParent = _selectedPath.last;
      final children = await _repository.getMkbByParentCode(lastParent.code);
      _mkbCategories = children;
      _currentParent = lastParent;
      notifyListeners();
    }
  }

  Future<void> navigateToLevel(MkbCategory category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final index = _selectedPath.indexWhere((item) => item.code == category.code);

      if (index != -1) {
        _selectedPath = _selectedPath.sublist(0, index + 1);

        final children = await _repository.getMkbByParentCode(category.code);
        _mkbCategories = children;
        _currentParent = category;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}