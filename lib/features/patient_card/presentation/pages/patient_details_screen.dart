import 'package:flutter/material.dart';
import 'package:neo_friend/features/patient_card/presentation/pages/diary_screen.dart';
import 'package:neo_friend/features/patient_card/presentation/pages/primary_exam_view_screen.dart';
import '../../../../models/patient.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.patient.motherName ?? 'Мать не указана',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editPatient,
          ),
        ],
        elevation: 4,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: PatientDetailsWidget(
              patient: widget.patient,
              onDiaryTap: _toggleDiary,
              onPrimaryExamTap: _togglePrimaryExam,
              onGenerateEpicrisisTap: _generateEpicrisis,
            ),
          ),
        ),
      ),
    );
  }

  void _toggleFavorite() {
    //  Добавить в избранное
  }

  void _editPatient() {
    // Редактирование пациента
  }

  void _toggleDiary() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiaryScreen(
          patientId: widget.patient.getId(),
        ),
      ),
    );
  }

  void _togglePrimaryExam() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrimaryExamViewScreen(
            patientId: widget.patient.getId(), examTypeId: 1,
        ),
      ),
    );
  }

  void _generateEpicrisis() {
    // Генерация эпикриза
  }
}