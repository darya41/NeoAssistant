import 'package:flutter/material.dart';
import '../../../../models/patient.dart';
import '../../data/repositories/favorite_repository.dart';
import '../pages/diary_screen.dart';
import '../pages/primary_exam_view_screen.dart';

class PatientDetailsViewModel extends ChangeNotifier {
  final Patient _patient;
  final FavoriteRepository _favoriteRepository = FavoriteRepository();

  bool _isFavorite = false;
  bool _isLoading = true;
  bool _isToggling = false;

  Patient get patient => _patient;
  bool get isFavorite => _isFavorite;
  bool get isLoading => _isLoading;
  bool get isToggling => _isToggling;
  String get title => _patient.motherName ?? 'Мать не указана';

  PatientDetailsViewModel({required Patient patient}) : _patient = patient {
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    try {
      _isFavorite = await _favoriteRepository.isFavorite(_patient.patientId);
    } catch (e) {
      print('Error checking favorite: $e');
      _isFavorite = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(BuildContext context) async {
    if (_isToggling) return;

    _isToggling = true;
    notifyListeners();

    try {
      await _favoriteRepository.toggleFavorite(_patient.patientId, _isFavorite);
      _isFavorite = !_isFavorite;
    } catch (e) {
      print('Error toggling favorite: $e');
    } finally {
      _isToggling = false;
      notifyListeners();
    }
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
    _isLoading = false;
    _isToggling = false;
    notifyListeners();
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}