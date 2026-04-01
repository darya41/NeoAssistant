import 'package:flutter/material.dart';
import '../../data/repositories/parameter_repository.dart';
import '../../domain/models/primary_exam_state.dart';
import '../widgets/form_fields/consent_section.dart';
import '../widgets/form_fields/parameters_list.dart';

class PrimaryExamViewScreen extends StatefulWidget {
  final int patientId;
  final int examTypeId;

  const PrimaryExamViewScreen({
    super.key,
    required this.patientId,
    required this.examTypeId,
  });

  @override
  State<PrimaryExamViewScreen> createState() => _PrimaryExamViewScreenState();
}

class _PrimaryExamViewScreenState extends State<PrimaryExamViewScreen> {
  final ParameterRepository _repository = ParameterRepository();
  final PrimaryExamState _state = PrimaryExamState();

  @override
  void initState() {
    super.initState();
    _loadParameters();
  }

  Future<void> _loadParameters() async {
    _state.setLoading(true);
    if (mounted) setState(() {});

    try {
      final patientExamId = await _repository.getPrimaryExamId(
        patientId: widget.patientId,
        examTypeId: widget.examTypeId,
      );

      if (patientExamId != null) {
        final parameters = await _repository.getParametersWithValues(
          examId: widget.examTypeId,
          patientExamId: patientExamId,
        );
        _state.setParameters(parameters);
      } else {
        _state.setParameters([]);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Первичный осмотр не найден'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Первичный осмотр новорождённого'),
        backgroundColor: const Color(0xFF44E4BF),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ConsentSectionWidget(),
          const SizedBox(height: 24),
          ParametersList(parameters: _state.parameters),
        ],
      ),
    );
  }
}