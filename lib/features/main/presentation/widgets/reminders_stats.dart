import 'package:flutter/material.dart';
import 'package:neo_friend/core/constants/app_colors.dart';
import '../../../reminders/data/repositories/reminder_repository.dart';
import 'reminder_card.dart';
import '../../../../shared/widgets/buttons/add_reminder_button.dart';

class RemindersStats extends StatefulWidget {
  const RemindersStats({super.key});

  @override
  State<RemindersStats> createState() => _RemindersStatsState();
}

class _RemindersStatsState extends State<RemindersStats> {
  final ReminderRepository _repository = ReminderRepository();

  List<Map<String, dynamic>> _remindersData = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRemindersStats();
  }

  Future<void> _loadRemindersStats() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final stats = await _repository.getRemindersStats();

      final todayCount = (stats['todayCount'] ?? 0).toString();
      final tomorrowCount = (stats['tomorrowCount'] ?? 0).toString();
      final tomorrowDate = stats['tomorrowDate'] ?? '';

      setState(() {
        _remindersData = [
          {
            'count': todayCount,
            'label': 'напоминаний сегодня',
            'isToday': true,
          },
          if (tomorrowCount != '0')
            {
              'count': tomorrowCount,
              'label': 'напоминаний $tomorrowDate',
              'isToday': false,
            },
        ];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: AppColors.primary,
        height: 120,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (_errorMessage != null) {
      return Container(
        color: AppColors.primary,
        height: 120,
        child: Center(
          child: Text(
            'Ошибка загрузки',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Container(
      color: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _remindersData.length + 1,
                itemBuilder: (context, index) {
                  if (index == _remindersData.length) {
                    return const AddReminderButton();
                  }
                  final data = _remindersData[index];
                  return ReminderCard(
                    count: data['count'] as String,
                    label: data['label'] as String,
                    isToday: data['isToday'] as bool,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}