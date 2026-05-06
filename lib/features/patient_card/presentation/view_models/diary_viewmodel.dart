import 'package:flutter/material.dart';
import '../../../../models/diary_entry.dart';
import '../../data/repositories/patient_exam_repository.dart';
import 'dart:developer';

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
    log('DiaryViewModel created: patientId=$patientId');
    loadDailyExams();
  }

  Future<void> loadDailyExams() async {
    log('loadDailyExams STARTED for patientId=$patientId');
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
        final utcDateTime = DateTime.parse(exam['date_time']);
        final displayDateTime = utcDateTime.add(const Duration(hours: 3));
        final date = DateTime(displayDateTime.year, displayDateTime.month, displayDateTime.day);

        if (!grouped.containsKey(date)) {
          grouped[date] = [];
        }

        grouped[date]!.add(DiaryEntry(
          text: 'Осмотр новорожденного',
         time: TimeOfDay(hour: displayDateTime.hour, minute: displayDateTime.minute),
          examId: exam['patients_exams_id'],
          dateTime: displayDateTime,
        ));
      }

      _groupedEntries = grouped;
      _error = null;
     log('Loaded ${grouped.keys.length} days with exams');

    } catch (e) {
      log('Error in loadDailyExams: $e');
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
    final entries = _groupedEntries[date] ?? [];
    final sortedEntries = List<DiaryEntry>.from(entries);
    sortedEntries.sort((a, b) {
      final aTime = DateTime(0, 0, 0, a.time.hour, a.time.minute);
      final bTime = DateTime(0, 0, 0, b.time.hour, b.time.minute);
      return _isNewestFirst ? bTime.compareTo(aTime) : aTime.compareTo(bTime);
    });
    return sortedEntries;
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