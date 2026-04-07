import 'package:flutter/material.dart';
import '../../../../models/patient.dart';
import '../pages/diary_screen.dart';
import '../pages/primary_exam_view_screen.dart';

class PatientDetailsViewModel extends ChangeNotifier {
  final Patient _patient;

  bool _isFavorite = false;

  Patient get patient => _patient;
  bool get isFavorite => _isFavorite;
  String get title => _patient.motherName ?? 'Мать не указана';

  PatientDetailsViewModel({required Patient patient}) : _patient = patient {
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
  }

  Future<void> toggleFavorite() async {
  }

  void navigateToDiary(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiaryScreen(
          patientId: _patient.getId(),
        ),
      ),
    );
  }

  void navigateToPrimaryExam(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrimaryExamViewScreen(
          patientId: _patient.getId(),
          examTypeId: 1,
        ),
      ),
    );
  }

  void generateEpicrisis(BuildContext context) {
  }

  void reset() {
    _isFavorite = false;
    notifyListeners();
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}