import 'package:flutter/material.dart';
import '../../domain/entities/reminder.dart';
import '../../data/repositories/reminder_repository.dart';

class RemindersViewModel extends ChangeNotifier {
  final ReminderRepository _repository = ReminderRepository();

  List<Reminder> _reminders = [];
  bool _sortNewFirst = true;
  bool _isEditing = false;
  bool _isLoading = true;
  String? _errorMessage;

  List<Reminder> get reminders => _reminders;
  bool get sortNewFirst => _sortNewFirst;
  bool get isEditing => _isEditing;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<Reminder> get sortedReminders {
    final sorted = List<Reminder>.from(_reminders);
    if (_sortNewFirst) {
      sorted.sort((a, b) => b.date.compareTo(a.date));
    } else {
      sorted.sort((a, b) => a.date.compareTo(b.date));
    }
    return sorted;
  }

  bool get hasReminders => _reminders.isNotEmpty;
  bool get isEmpty => _reminders.isEmpty;

  RemindersViewModel() {
    loadReminders();
  }

  Future<void> loadReminders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final reminders = await _repository.getReminders();
      _reminders = reminders;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleSort() {
    _sortNewFirst = !_sortNewFirst;
    notifyListeners();
  }

  void toggleEditing() {
    _isEditing = !_isEditing;
    notifyListeners();
  }

  Future<bool> toggleReminderStatus(int index, bool value) async {
    if (index >= _reminders.length) return false;

    final reminder = _reminders[index];
    final originalStatus = reminder.isCompleted;

    _reminders[index].isCompleted = value;
    notifyListeners();

    try {
      await _repository.toggleReminderStatus(reminder.id, value);
      return true;
    } catch (e) {
      _reminders[index].isCompleted = originalStatus;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteReminder(int index) async {
    if (index >= _reminders.length) return false;

    final reminder = _reminders[index];
    final removedReminder = reminder;

    _reminders.removeAt(index);
    notifyListeners();

    try {
      await _repository.deleteReminder(reminder.id);
      return true;
    } catch (e) {
      _reminders.insert(index, removedReminder);
      notifyListeners();
      return false;
    }
  }

  void refreshAfterCreate() {
    loadReminders();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}