import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../models/diary_entry.dart';
import '../../data/repositories/patient_exam_repository.dart';
import '../../../../core/utils/date_formatter.dart';
import 'add_daily_exam_screen.dart';
import 'daily_exam_view_screen.dart';

class DiaryScreen extends StatefulWidget {
  final int patientId;

  const DiaryScreen({
    super.key,
    required this.patientId,
  });

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final PatientExamRepository _patientExamRepository = PatientExamRepository();

  Map<DateTime, List<DiaryEntry>> _groupedEntries = {};
  bool _isLoading = true;
  String? _error;

  bool _isNewestFirst = true;

  @override
  void initState() {
    super.initState();
    _loadDailyExams();
  }

  Future<void> _loadDailyExams() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final exams = await _patientExamRepository.getPatientExamsByType(
        patientId: widget.patientId,
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

      setState(() {
        _groupedEntries = grouped;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<DateTime> _getSortedDates() {
    List<DateTime> dates = _groupedEntries.keys.toList();
    dates.sort((a, b) => _isNewestFirst ? b.compareTo(a) : a.compareTo(b));
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Дневник наблюдений',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.black,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _isNewestFirst = value == 'newest';
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'newest',
                child: Row(
                  children: [
                    if (_isNewestFirst) const Icon(Icons.check, size: 18),
                    const SizedBox(width: 8),
                    const Text('Сначала новые'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'oldest',
                child: Row(
                  children: [
                    if (!_isNewestFirst) const Icon(Icons.check, size: 18),
                    const SizedBox(width: 8),
                    const Text('Сначала старые'),
                  ],
                ),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: const [
                  Text('Сначала новые'),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: const TextStyle(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadDailyExams,
              child: const Text(AppStrings.retry),
            ),
          ],
        ),
      );
    }

    if (_groupedEntries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.medical_information,
              size: 64,
              color: AppColors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Нет записей',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadDailyExams,
              child: const Text('Обновить'),
            ),
          ],
        ),
      );
    }

    final sortedDates = _getSortedDates();

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: sortedDates.length,
            itemBuilder: (context, index) {
              final date = sortedDates[index];
              final entries = _groupedEntries[date]!;
              return _buildDateSection(date, entries);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _addObservation,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '+ Добавить наблюдение',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSection(DateTime date, List<DiaryEntry> entries) {
    final dateFormat = DateFormatter.formatDateWithToday(date);
    final isToday = DateFormatter.isToday(date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            dateFormat,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isToday ? AppColors.primary : Colors.grey.shade700,
            ),
          ),
        ),
        ...entries.asMap().entries.map((entry) => _buildEntryCard(
          entry.value,
          entry.key + 1,
        )),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildEntryCard(DiaryEntry entry, int number) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DailyExamViewScreen(
              patientId: widget.patientId,
              examId: entry.examId,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.text,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormatter.formatTime(entry.time),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addObservation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddDailyExamScreen(
          patientId: widget.patientId,
        ),
      ),
    ).then((_) {
      _loadDailyExams();
    });
  }
}