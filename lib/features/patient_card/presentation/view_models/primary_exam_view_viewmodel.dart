import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/repositories/exam_metadata_repository.dart';
import '../../data/repositories/exam_parameter_repository.dart';
import '../../domain/models/primary_exam_state.dart';
import '../../domain/entities/medical_parameter_value.dart';

class PrimaryExamViewViewModel extends ChangeNotifier {
  final ExamParameterRepository _parameterRepository = ExamParameterRepository();
  final ExamMetadataRepository _metadataRepository = ExamMetadataRepository();
  final PrimaryExamState _state = PrimaryExamState();

  final int patientId;
  final int examTypeId;

  bool get isLoading => _state.isLoading;
  String? get error => _state.error;
  List<MedicalParameterValue> get parameters => _state.parameters;
  bool get hasParameters => _state.parameters.isNotEmpty;
  bool get hasError => _state.error != null;

  PrimaryExamViewViewModel({
    required this.patientId,
    required this.examTypeId,
  }) {
    loadParameters();
  }

  Future<void> loadParameters() async {
    _state.setLoading(true);
    notifyListeners();

    try {
      final patientExamId = await _metadataRepository.getPrimaryExamId(
        patientId: patientId,
        examTypeId: examTypeId,
      );

      if (patientExamId != null) {
        final parameters = await _parameterRepository.getParametersWithValues(
          examId: examTypeId,
          patientExamId: patientExamId,
        );
        _state.setParameters(parameters);
        _state.setError(null);
      } else {
        _state.setParameters([]);
        _state.setError('Первичный осмотр не найден');
      }
    } catch (e) {
      _state.setError(e.toString());
      _state.setParameters([]);
    } finally {
      _state.setLoading(false);
      notifyListeners();
    }
  }

  void showErrorSnackBar(BuildContext context) {
    if (_state.error != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_state.error!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void refresh() {
    loadParameters();
  }

  void reset() {
    _state.reset();
    notifyListeners();
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}