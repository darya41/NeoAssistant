import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/diary_entry.dart';
import '../../../../core/utils/date_formatter.dart';
import '../view_models/diary_viewmodel.dart';
import 'add_daily_exam_screen.dart';
import 'daily_exam_view_screen.dart';
import 'dart:developer';

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
  late final DiaryViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = DiaryViewModel(patientId: widget.patientId);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
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
      _viewModel.refresh();
    });
  }

  void _goBack() {
      Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        log('ListenableBuilder rebuild: isLoading=${_viewModel.isLoading}, hasError=${_viewModel.error != null}, hasEntries=${_viewModel.hasEntries}');
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Дневник наблюдений',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _goBack,
            ),
            backgroundColor: AppColors.neutral_0,
            elevation: 0,
            foregroundColor: AppColors.neutral_90,
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  _viewModel.toggleSortOrder(value == 'newest');
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'newest',
                    child: Row(
                      children: [
                        if (_viewModel.isNewestFirst) const Icon(Icons.check, size: 18),
                        const SizedBox(width: 8),
                        const Text('Сначала новые'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'oldest',
                    child: Row(
                      children: [
                        if (!_viewModel.isNewestFirst) const Icon(Icons.check, size: 18),
                        const SizedBox(width: 8),
                        const Text('Сначала старые'),
                      ],
                    ),
                  ),
                ],
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(_viewModel.isNewestFirst ? 'Сначала новые' : 'Сначала старые'),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildBody() {
    if (_viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.error != null) {
      log('Showing error: ${_viewModel.error}');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _viewModel.error!,
              style: const TextStyle(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _viewModel.refresh(),
              child: const Text(AppStrings.retry),
            ),
          ],
        ),
      );
    }

    if (!_viewModel.hasEntries) {
      return Column(
        children: [
          const Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.medical_information,
                    size: 64,
                    color: AppColors.neutral_50,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Нет записей',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.neutral_50,
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addObservation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brand_40,
                  foregroundColor: AppColors.neutral_0,
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

    final sortedDates = _viewModel.getSortedDates();

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: sortedDates.length,
            itemBuilder: (context, index) {
              final date = sortedDates[index];
              final entries = _viewModel.getEntriesForDate(date);
              log('Building item $index: date=$date, entries=${entries.length}');
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
                backgroundColor: AppColors.brand_40,
                foregroundColor: AppColors.neutral_0,
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
              color: isToday ? AppColors.brand_40 : Colors.grey.shade700,
            ),
          ),
        ),
        ...entries.asMap().entries.map((entry) {
          log('Building entry card #${entry.key + 1} for date $dateFormat');
          return _buildEntryCard(
            entry.value,
            entry.key + 1,
          );
        }),
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
          color: AppColors.neutral_0,
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
}