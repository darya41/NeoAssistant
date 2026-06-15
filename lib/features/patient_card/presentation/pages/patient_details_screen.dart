import 'package:flutter/material.dart';
import '../../domain/entities/patient.dart';
import '../view_models/patient_details_viewmodel.dart';
import '../widgets/patient_details_widget.dart';

class PatientDetailsScreen extends StatefulWidget {
  final Patient patient;

  const PatientDetailsScreen({
    super.key,
    required this.patient,
  });

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  late final PatientDetailsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = PatientDetailsViewModel(patient: widget.patient);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              _viewModel.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: [
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      _viewModel.isFavorite ? Icons.star : Icons.star_border,
                      color: _viewModel.isFavorite ? Colors.white : Colors.white,
                    ),
                    onPressed: _viewModel.isToggling ? null : () => _viewModel.toggleFavorite(context),
                  ),
                  if (_viewModel.isToggling)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ],
            elevation: 4,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: PatientDetailsWidget(
                  patient: _viewModel.patient,
                  onDiaryTap: () => _viewModel.navigateToDiary(context),
                  onPrimaryExamTap: () => _viewModel.navigateToPrimaryExam(context),
                  onGenerateEpicrisisTap: () => _viewModel.generateEpicrisis(context),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}