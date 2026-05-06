import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../models/patient.dart';
import '../../../../shared/widgets/buttons/continue_button.dart';
import '../../data/repositories/mother_repository.dart';
import '../../domain/models/patient_details_state.dart';
import 'form_fields/info_column.dart';
import 'form_fields/patient_header.dart';

class PatientDetailsWidget extends StatefulWidget {
  final Patient patient;
  final VoidCallback onDiaryTap;
  final VoidCallback onPrimaryExamTap;
  final VoidCallback onGenerateEpicrisisTap;

  const PatientDetailsWidget({
    super.key,
    required this.patient,
    required this.onDiaryTap,
    required this.onPrimaryExamTap,
    required this.onGenerateEpicrisisTap,
  });

  @override
  State<PatientDetailsWidget> createState() => _PatientDetailsWidgetState();
}

class _PatientDetailsWidgetState extends State<PatientDetailsWidget> {
  final MotherRepository _motherRepository = MotherRepository();
  late PatientDetailsState _state;

  @override
  void initState() {
    super.initState();
    _state = PatientDetailsState(
      patient: widget.patient,
      isLoadingMother: true,
    );
    _loadMother();
  }

  Future<void> _loadMother() async {
    if (widget.patient.motherId == 0) {
      setState(() {
        _state = _state.copyWith(
          isLoadingMother: false,
        );
      });
      return;
    }

    try {
      final mother = await _motherRepository.getMotherById(widget.patient.motherId);
      setState(() {
        _state = _state.copyWith(
          mother: mother,
          isLoadingMother: false,
          motherError: null,
        );
      });
    } catch (e) {
      setState(() {
        _state = _state.copyWith(
          motherError: e.toString(),
          isLoadingMother: false,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PatientHeader(
          numberHistory: widget.patient.numberHistory,
          motherName: widget.patient.motherName ?? 'Мать не указана',
        ),
        const SizedBox(height: 24),

        Row(
          children: [
            InfoColumnWidget(
              label: 'Дата родов',
              value: '${_state.formattedBirthDate} ${_state.formattedBirthTime}',
            ),
            const SizedBox(width: 16),
            InfoColumnWidget(
              label: 'Г.К. Матери',
              value: _state.formattedMotherBloodGroup,
            ),
          ],
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            InfoColumnWidget(
              label: 'Пол Ребёнка',
              value: _state.formattedGender,
            ),
            const SizedBox(width: 16),
            InfoColumnWidget(
              label: 'Г.К. Ребёнка',
              value: _state.formattedChildBloodGroup,
            ),
          ],
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            InfoColumnWidget(
              label: 'Вес Ребёнка',
              value: _state.patient.formattedWeight,
            ),
            const SizedBox(width: 16),
            InfoColumnWidget(
              label: 'Рост Ребёнка',
              value: _state.patient.formattedHeight,
            ),
          ],
        ),
        const SizedBox(height: 32),

        _buildActionButtons(),
        const SizedBox(height: 24),

        _buildWeightGraphSection(context),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ContinueButton(
          isEnabled: true,
          onPressed: widget.onDiaryTap,
          text: 'Дневник наблюдений',
          backgroundColor: AppColors.brand_40,
          borderColor: AppColors.brand_40,
        ),
        const SizedBox(height: 8),

        ContinueButton(
          isEnabled: true,
          onPressed: widget.onPrimaryExamTap,
          text: 'Первичный осмотр',
          backgroundColor: AppColors.white,
          borderColor: AppColors.grey,
        ),
        const SizedBox(height: 8),

        ContinueButton(
          isEnabled: true,
          onPressed: widget.onGenerateEpicrisisTap,
          text: 'Сгенерировать эпикриз',
          backgroundColor: AppColors.white,
          borderColor: AppColors.grey,
        ),
      ],
    );
  }

  Widget _buildWeightGraphSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionTile(
          title: const Text(
            'График веса',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: const Icon(Icons.expand_more),
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.show_chart,
                      size: 48,
                      color: AppColors.grey,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'График веса будет отображаться здесь',
                      style: TextStyle(color: AppColors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}