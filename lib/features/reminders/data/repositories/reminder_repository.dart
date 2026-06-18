import '../../domain/entities/reminder.dart';
import '../service/reminder_service.dart';

class ReminderRepository {
  final ReminderService _service = ReminderService();

  Future<Map<String, dynamic>> getRemindersStats() async {
    try {
      final response = await _service.getRemindersStats();
      return {
        'todayCount': response['todayCount']?.toString() ?? '0',
        'tomorrowCount': response['tomorrowCount']?.toString() ?? '0',
        'tomorrowDate': _formatDate(response['tomorrowDate']),
      };
    } catch (e) {
      return {
        'todayCount': '0',
        'tomorrowCount': '0',
        'tomorrowDate': '',
      };
    }
  }

  Future<Map<String, dynamic>> getRemindersWithPagination({int daysToShow = 0}) async {
    try {
      final response = await _service.getRemindersWithPagination(daysToShow: daysToShow);
      final List<dynamic> data = response['data'] ?? [];
      return {
        'reminders': data.map((json) => Reminder.fromJson(json)).toList(),
        'summary': response['summary'] ?? {},
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleReminderStatus(int reminderId, bool isCompleted) async {
    try {
      await _service.updateReminderStatus(reminderId, isCompleted ? 1 : 0);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markAsCompleted(int id) async {
    try {
      await _service.updateReminderStatus(id, 1);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteReminder(int reminderId) async {
    try {
      await _service.deleteReminder(reminderId);
    } catch (e) {
      rethrow;
    }
  }

  Future<Reminder> getReminderById(int id) async {
    try {
      final response = await _service.getReminderById(id);
      return Reminder.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<Reminder> createReminder({
    required String title,
    String? description,
    required DateTime date,
  }) async {
    try {
      final response = await _service.createReminder({
        'title': title,
        'description': description,
        'reminder_date': date.toIso8601String().split('T')[0],
      });

      if (response['success'] == true) {
        return Reminder.fromJson(response['data']);
      } else {
        throw Exception(response['error'] ?? 'Ошибка создания напоминания');
      }
    } catch (e) {
      rethrow;
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      const months = [
        'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
        'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
      ];
      return '${date.day} ${months[date.month - 1]}';
    } catch (e) {
      return '';
    }
  }
}