import 'package:flutter/material.dart';
import '../../data/repositories/reminder_repository.dart';

class ReminderDetailViewModel extends ChangeNotifier {
  final ReminderRepository _repository = ReminderRepository();

  final int reminderId;
  final String initialTitle;
  final String initialDescription;

  bool _isEditing = false;
  bool _isLoading = false;
  bool _isCompleted = false;
  String? _errorMessage;
  String _title;
  String _description;

  bool get isEditing => _isEditing;
  bool get isLoading => _isLoading;
  bool get isCompleted => _isCompleted;
  String? get errorMessage => _errorMessage;
  String get title => _title;
  String get description => _description;

  ReminderDetailViewModel({
    required this.reminderId,
    required this.initialTitle,
    required this.initialDescription,
  }) : _title = initialTitle, _description = initialDescription {
    _loadReminder();
  }

  Future<void> _loadReminder() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final reminder = await _repository.getReminderById(reminderId);
      _isCompleted = reminder.isCompleted;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleEditing() {
    _isEditing = !_isEditing;
    notifyListeners();
  }

  void updateTitle(String newTitle) {
    _title = newTitle;
    notifyListeners();
  }

  void updateDescription(String newDescription) {
    _description = newDescription;
    notifyListeners();
  }

  Future<bool> markAsCompleted(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.markAsCompleted(reminderId);
      _isCompleted = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteReminder(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удаление'),
        content: const Text('Вы уверены, что хотите удалить это напоминание?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirm != true) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteReminder(reminderId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> saveChanges() async {
    _isEditing = false;
    notifyListeners();
    return true;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}