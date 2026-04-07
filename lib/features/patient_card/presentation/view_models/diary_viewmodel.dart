import 'package:flutter/material.dart';
import '../../../../models/diary_entry.dart';
import '../../data/repositories/patient_exam_repository.dart';

class DiaryViewModel extends ChangeNotifier {
  final PatientExamRepository _patientExamRepository = PatientExamRepository();

  final int patientId;

  Map<DateTime, List<DiaryEntry>> _groupedEntries = {};
  bool _isLoading = true;
  String? _error;
  bool _isNewestFirst = true;

  Map<DateTime, List<DiaryEntry>> get groupedEntries => _groupedEntries;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isNewestFirst => _isNewestFirst;
  bool get hasEntries => _groupedEntries.isNotEmpty;

  DiaryViewModel({required this.patientId}) {
    loadDailyExams();
  }

  Future<void> loadDailyExams() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final exams = await _patientExamRepository.getPatientExamsByType(
        patientId: patientId,
        examTypeId: 2,
      );

      final Map<DateTime, List<DiaryEntry>> grouped = {};

      for (var exam in exams) {
        final dateTime = DateTime.parse(exam['date_time']);
        final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

        if (!grouped.containsKey(date)) {
          grouped[date] = [];
        }

        grouped[date]!.add(DiaryEntry(
          text: 'Осмотр новорожденного',
          time: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
          examId: exam['patients_exams_id'],
          dateTime: dateTime,
        ));
      }

      _groupedEntries = grouped;
      _error = null;
    } catch (e) {
      _error = e.toString();
      _groupedEntries = {};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleSortOrder(bool isNewestFirst) {
    if (_isNewestFirst != isNewestFirst) {
      _isNewestFirst = isNewestFirst;
      notifyListeners();
    }
  }

  List<DateTime> getSortedDates() {
    List<DateTime> dates = _groupedEntries.keys.toList();
    dates.sort((a, b) => _isNewestFirst ? b.compareTo(a) : a.compareTo(b));
    return dates;
  }

  List<DiaryEntry> getEntriesForDate(DateTime date) {
    return _groupedEntries[date] ?? [];
  }

  void refresh() {
    loadDailyExams();
  }

  void reset() {
    _groupedEntries = {};
    _isLoading = true;
    _error = null;
    _isNewestFirst = true;
    notifyListeners();
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}