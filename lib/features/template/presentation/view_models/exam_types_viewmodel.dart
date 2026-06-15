// lib/features/exams/presentation/view_models/exam_types_viewmodel.dart
import 'package:flutter/material.dart';
import '../../domain/entities/exam_type.dart';
import '../../data/repositories/exam_type_repository.dart';

class ExamTypesViewModel extends ChangeNotifier {
  final ExamTypeRepository _repository = ExamTypeRepository();

  List<ExamType> _examTypes = [];
  bool _isLoading = false;
  String? _error;

  List<ExamType> get examTypes => _examTypes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadExamTypes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _examTypes = await _repository.getAllExamTypes();

      if (_examTypes.isEmpty) {
        _error = 'Нет доступных шаблонов';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void refresh() {
    loadExamTypes();
  }
}