import 'package:flutter/material.dart';
import 'package:neo_friend/features/patient_card/presentation/pages/diary_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/repositories/parameter_repository.dart';
import '../../domain/models/daily_exam_state.dart';

class DailyExamViewScreen extends StatefulWidget {
  final int patientId;
  final int examId;

  const DailyExamViewScreen({
    super.key,
    required this.patientId,
    required this.examId,
  });

  @override
  State<DailyExamViewScreen> createState() => _DailyExamViewScreenState();
}

class _DailyExamViewScreenState extends State<DailyExamViewScreen> {
  final ParameterRepository _repository = ParameterRepository();
  final DailyExamState _state = DailyExamState();

  String _examDateTime = '';
  String _examTitle = 'Ежедневное наблюдение пациента';

  @override
  void initState() {
    super.initState();
    _loadParameters();
  }

  Future<void> _loadParameters() async {
    _state.setLoading(true);
    if (mounted) setState(() {});

    try {

      final parameters = await _repository.getParametersWithValuesByExamId(
        patientExamId: widget.examId,
      );
      _state.setParameters(parameters);

      await _loadExamDateTime(widget.examId);

      await _loadExamType(widget.examId);

    } catch (e) {
      _state.setError(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки: $e')),
        );
      }
    } finally {
      _state.setLoading(false);
      if (mounted) setState(() {});
    }
  }

  Future<void> _loadExamDateTime(int patientExamId) async {
      final examDateTime = await _repository.getExamDateTime(patientExamId);
      if (examDateTime != null) {
        setState(() {
          _examDateTime = _formatDateTime(examDateTime);
        });
      }
  }

  Future<void> _loadExamType(int patientExamId) async {
      final examType = await _repository.getExamTypeByExamId(patientExamId);
      if (examType != null) {
        setState(() {
          _examTitle = examType;
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Переопределяем поведение стрелки "Назад"
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Ваша кастомная логика
            _showExitConfirmationDialog();
          },
          tooltip: 'Назад',
        ),
        title: Text(_examTitle),
        backgroundColor: AppColors.primary,
        // Отключаем стандартную стрелку, чтобы не было дублирования
        automaticallyImplyLeading: false,
      ),
      body: _buildBody(),
    );
  }

  void _showExitConfirmationDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiaryScreen(
          patientId: widget.patientId,
        ),
      ),
    ).then((_) {
    });
  }

  Widget _buildBody() {
    if (_state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _state.error!,
              style: const TextStyle(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadParameters,
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (_state.parameters.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medical_information,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Нет данных для отображения',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Text(
              _examDateTime.isNotEmpty ? _examDateTime : 'Дата не указана',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8),

          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Дневник наблюдений',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _buildParametersText(),
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _buildParametersText() {
    final List<String> parameterStrings = [];

    for (var param in _state.parameters) {
      final hasValue = param.value != null && param.value!.isNotEmpty;
      final value = hasValue ? param.value! : '—';
      parameterStrings.add('${param.name} $value');
    }

    return parameterStrings.join('. ');
  }
}