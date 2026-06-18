import 'package:flutter/material.dart';
import '../../domain/entities/reminder.dart';
import '../../data/repositories/reminder_repository.dart';

class RemindersViewModel extends ChangeNotifier {
  final ReminderRepository _repository = ReminderRepository();

  List<Reminder> _allReminders = [];
  List<Reminder> _displayedReminders = [];
  bool _sortNewFirst = true;
  bool _isEditing = false;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _errorMessage;

  int _daysToShow = 3;
  static const int _daysIncrement = 3;
  bool _hasMore = true;
  Map<String, dynamic> _summary = {};

  List<String> _shownDays = [];

  List<Reminder> get reminders => _displayedReminders;
  bool get sortNewFirst => _sortNewFirst;
  bool get isEditing => _isEditing;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;
  bool get hasReminders => _displayedReminders.isNotEmpty;
  bool get isEmpty => _displayedReminders.isEmpty && !_isLoading;

  int get currentDaysShowing => _shownDays.length;

  RemindersViewModel() {
    loadReminders();
  }

  Future<void> loadReminders() async {
    _isLoading = true;
    _errorMessage = null;
    _daysToShow = 3;
    _hasMore = true;
    notifyListeners();

    try {
      final result = await _repository.getRemindersWithPagination(daysToShow: _daysToShow);
      _allReminders = result['reminders'];
      _summary = result['summary'] ?? {};
      _hasMore = _summary['hasMorePastDays'] ?? false;
      _shownDays = List<String>.from(_summary['shownDays'] ?? []);

      _updateDisplayedReminders();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreDays() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      _daysToShow += _daysIncrement;

      final result = await _repository.getRemindersWithPagination(daysToShow: _daysToShow);
      _allReminders = result['reminders'];
      _summary = result['summary'] ?? {};
      _hasMore = _summary['hasMorePastDays'] ?? false;
      _shownDays = List<String>.from(_summary['shownDays'] ?? []);

      _updateDisplayedReminders();

    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void _updateDisplayedReminders() {
    final sorted = List<Reminder>.from(_allReminders);
    if (_sortNewFirst) {
      sorted.sort((a, b) => b.date.compareTo(a.date));
    } else {
      sorted.sort((a, b) => a.date.compareTo(b.date));
    }
    _displayedReminders = sorted;
    notifyListeners();
  }

  void toggleSort() {
    _sortNewFirst = !_sortNewFirst;
    _updateDisplayedReminders();
  }

  void toggleEditing() {
    _isEditing = !_isEditing;
    notifyListeners();
  }

  Future<bool> toggleReminderStatus(int index, bool value) async {
    if (index >= _displayedReminders.length) return false;

    final reminder = _displayedReminders[index];
    final originalStatus = reminder.isCompleted;

    reminder.isCompleted = value;
    _updateDisplayedReminders();

    try {
      await _repository.toggleReminderStatus(reminder.id, value);
      return true;
    } catch (e) {
      reminder.isCompleted = originalStatus;
      _updateDisplayedReminders();
      return false;
    }
  }

  Future<bool> deleteReminder(int index) async {
    if (index >= _displayedReminders.length) return false;

    final reminder = _displayedReminders[index];
    final removedReminder = reminder;

    _displayedReminders.removeAt(index);
    notifyListeners();

    try {
      await _repository.deleteReminder(reminder.id);
      await loadReminders();
      return true;
    } catch (e) {
      _displayedReminders.insert(index, removedReminder);
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