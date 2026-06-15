import 'package:flutter/material.dart';
import '../../../patient_card/domain/entities/medical_parameter.dart';
import '../../../patient_card/data/repositories/exam_parameter_repository.dart';

class TemplateDetailViewModel extends ChangeNotifier {
  final ExamParameterRepository _repository = ExamParameterRepository();

  List<MedicalParameter> _parameters = [];
  bool _isLoading = true;
  String? _error;
  int _examId = 0;

  List<MedicalParameter> get parameters => _parameters;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get examId => _examId;

  Future<void> loadParameters(int examId) async {
    _examId = examId;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _parameters = await _repository.getParameters(examId);

      if (_parameters.isEmpty) {
        _error = 'Нет данных для отображения';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void refresh() {
    if (_examId != 0) {
      loadParameters(_examId);
    }
  }
}