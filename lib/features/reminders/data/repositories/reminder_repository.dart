import '../../../../core/network/api_client.dart';
import '../../../../models/reminder.dart';

class ReminderRepository {
  Future<Map<String, dynamic>> getRemindersStats() async {
    try {
      final response = await ApiClient.getAuth('reminders/stats');
      return {
        'count': response['todayCount'].toString(),
        'tomorrowCount': response['tomorrowCount'].toString(),
        'tomorrowDate': _formatDate(response['tomorrowDate']),
      };
    } catch (e) {
      return {
        'count': '0',
        'tomorrowCount': '0',
        'tomorrowDate': '',
      };
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

  Future<List<Reminder>> getReminders() async {
    try {
      final response = await ApiClient.getAuth('reminders');
      final List<dynamic> data = response['data'] ?? [];
      return data.map((json) => Reminder.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleReminderStatus(int reminderId, bool isCompleted) async {
    try {
      await ApiClient.putAuth('reminders/$reminderId', {
        'is_completed': isCompleted ? 1 : 0,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteReminder(int reminderId) async {
    try {
      await ApiClient.deleteAuth('reminders/$reminderId');
    } catch (e) {
      rethrow;
    }
  }

  Future<Reminder> getReminderById(int id) async {
    try {
      final response = await ApiClient.getAuth('reminders/$id');
      return Reminder.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markAsCompleted(int id) async {
    try {
      await ApiClient.putAuth('reminders/$id', {
        'is_completed': 1,
      });
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
      final response = await ApiClient.postAuth('reminders', {
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
}