import 'package:flutter/material.dart';
import '../../data/repositories/exam_metadata_repository.dart';
import '../../data/repositories/exam_parameter_repository.dart';
import '../../domain/entities/medical_parameter_value.dart';
import '../../domain/models/daily_exam_state.dart';

class DailyExamViewViewModel extends ChangeNotifier {
  final ExamParameterRepository _parameterRepository = ExamParameterRepository();
  final ExamMetadataRepository _metadataRepository = ExamMetadataRepository();
  final DailyExamState _state = DailyExamState();

  final int patientId;
  final int examId;

  String _examDateTime = '';
  String _examTitle = 'Ежедневное наблюдение пациента';

  static const Duration serverTimeOffset = Duration(hours: 3);

  bool get isLoading => _state.isLoading;
  String? get error => _state.error;
  List<MedicalParameterValue> get parameters => _state.parameters;
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
      final results = await Future.wait([
        _parameterRepository.getParametersWithValuesByExamId(patientExamId: examId),
        _metadataRepository.getExamDateTime(examId),
        _metadataRepository.getExamTypeByExamId(examId),
      ]);

      final parameters = results[0] as List<MedicalParameterValue>;
      final examDateTime = results[1] as DateTime?;
      final examType = results[2] as String?;

      _state.setParameters(parameters);

      if (examDateTime != null) {
        final serverLocalDateTime = examDateTime.add(serverTimeOffset);
        _examDateTime = _formatDateTime(serverLocalDateTime);
        debugPrint('Дата осмотра (UTC): $examDateTime');
        debugPrint('Дата осмотра (серверное время UTC+3): $serverLocalDateTime');
        debugPrint('Отформатированная дата: $_examDateTime');
      } else {
        _examDateTime = '';
        debugPrint('Дата осмотра не найдена для examId: $examId');
      }

      if (examType != null && examType.isNotEmpty) {
        _examTitle = examType;
      } else {
        _examTitle = 'Ежедневное наблюдение пациента';
      }

    } catch (e) {
      _state.setError(e.toString());
      debugPrint('Ошибка загрузки данных: $e');
    } finally {
      _state.setLoading(false);
      notifyListeners();
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
    if (_state.parameters.isEmpty) {
      return 'Нет параметров';
    }

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