import 'package:flutter/material.dart';
import '../../../protocol/domain/entities/tech_level.dart';
import '../../data/repositories/tech_level_repository.dart';

class TechLevelViewModel extends ChangeNotifier {
  final TechLevelRepository _repository = TechLevelRepository();

  TechLevel? _currentLevel;
  List<TechLevel> _allLevels = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;

  TechLevel? get currentLevel => _currentLevel;
  List<TechLevel> get allLevels => _allLevels;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;

  bool get hasLevel => _currentLevel != null;
  String get currentLevelName => _currentLevel?.name ?? 'Не выбран';
  int get currentLevelPriority => _currentLevel?.priority ?? 0;

  TechLevelViewModel() {
    loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allLevels = await _repository.getAllTechLevels();

      final userLevel = await _repository.getMyTechLevel();

      if (userLevel != null && userLevel.id != 0) {
        TechLevel? foundLevel;
        for (final level in _allLevels) {
          if (level.id == userLevel.id) {
            foundLevel = level;
            break;
          }
        }
        _currentLevel = foundLevel;
      } else {
        _currentLevel = null;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveLevel(TechLevel level) async {
    if (_currentLevel?.id == level.id) {
      return true;
    }

    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _repository.updateMyTechLevel(level.id);

      if (success) {
        await loadData();
        notifyListeners();

        Future.delayed(const Duration(seconds: 3), () {
          notifyListeners();
        });

        return true;
      } else {
        _error = 'Не удалось сохранить уровень';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearSuccessMessage() {
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadData();
  }

  TechLevel? getNextLevel() {
    if (_currentLevel == null) return null;
    try {
      for (final level in _allLevels) {
        if (level.priority == _currentLevel!.priority + 1) {
          return level;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  TechLevel? getPreviousLevel() {
    if (_currentLevel == null) return null;
    try {
      for (final level in _allLevels) {
        if (level.priority == _currentLevel!.priority - 1) {
          return level;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}