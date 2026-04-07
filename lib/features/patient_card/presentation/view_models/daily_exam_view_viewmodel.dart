import 'package:flutter/material.dart';
import '../../data/repositories/exam_metadata_repository.dart';
import '../../data/repositories/exam_parameter_repository.dart';
import '../../domain/models/daily_exam_state.dart';

class DailyExamViewViewModel extends ChangeNotifier {
  final ExamParameterRepository _parameterRepository = ExamParameterRepository();
  final ExamMetadataRepository _metadataRepository = ExamMetadataRepository();
  final DailyExamState _state = DailyExamState();

  final int patientId;
  final int examId;

  String _examDateTime = '';
  String _examTitle = 'Ежедневное наблюдение пациента';

  bool get isLoading => _state.isLoading;
  String? get error => _state.error;
  List<dynamic> get parameters => _state.parameters;
  String get examDateTime => _examDateTime;
  String get examTitle => _examTitle;

  DailyExamViewViewModel({
    required this.patientId,
    required this.examId,
  }) {
    loadParameters();
  }

  Future<void> loadParameters() async {
    _state.setLoading(true);
    notifyListeners();

    try {
      final parameters = await _parameterRepository.getParametersWithValuesByExamId(
        patientExamId: examId,
      );
      _state.setParameters(parameters);

      await _loadExamDateTime();
      await _loadExamType();

    } catch (e) {
      _state.setError(e.toString());
    } finally {
      _state.setLoading(false);
      notifyListeners();
    }
  }

  Future<void> _loadExamDateTime() async {
    try {
      final examDateTime = await _metadataRepository.getExamDateTime(examId);
      if (examDateTime != null) {
        _examDateTime = _formatDateTime(examDateTime);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Ошибка загрузки даты осмотра: $e');
    }
  }

  Future<void> _loadExamType() async {
    try {
      final examType = await _metadataRepository.getExamTypeByExamId(examId);
      if (examType != null) {
        _examTitle = examType;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Ошибка загрузки типа осмотра: $e');
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final time = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    const months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];
    final date = '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
    return '$time   $date';
  }

  String buildParametersText() {
    final List<String> parameterStrings = [];

    for (var param in _state.parameters) {
      final hasValue = param.value != null && param.value!.isNotEmpty;
      final value = hasValue ? param.value! : '—';
      parameterStrings.add('${param.name} $value');
    }

    return parameterStrings.join('. ');
  }

  void showErrorSnackBar(BuildContext context) {
    if (_state.error != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки: ${_state.error}')),
      );
    }
  }

  void reset() {
    _state.reset();
    _examDateTime = '';
    _examTitle = 'Ежедневное наблюдение пациента';
    notifyListeners();
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}