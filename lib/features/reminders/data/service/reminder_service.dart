import '../../../../core/network/api_client.dart';

class ReminderService {
  Future<Map<String, dynamic>> getRemindersStats() async {
    return await ApiClient.getAuth('reminders/stats');
  }

  Future<Map<String, dynamic>> getRemindersWithPagination({int daysToShow = 0}) async {
    final response = await ApiClient.getAuth('reminders/paginated?daysToShow=$daysToShow');
    return response;
  }

  Future<void> updateReminderStatus(int reminderId, int isCompleted) async {
    await ApiClient.putAuth('reminders/$reminderId', {
      'is_completed': isCompleted,
    });
  }

  Future<void> deleteReminder(int reminderId) async {
    await ApiClient.deleteAuth('reminders/$reminderId');
  }

  Future<Map<String, dynamic>> getReminderById(int id) async {
    return await ApiClient.getAuth('reminders/$id');
  }

  Future<Map<String, dynamic>> createReminder(Map<String, dynamic> data) async {
    return await ApiClient.postAuth('reminders', data);
  }
}