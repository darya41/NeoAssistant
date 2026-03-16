import '../../../../core/network/api_client.dart';

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
}