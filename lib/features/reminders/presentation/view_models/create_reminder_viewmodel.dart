import 'package:flutter/material.dart';
import '../../data/repositories/reminder_repository.dart';

class CreateReminderViewModel extends ChangeNotifier {
  final ReminderRepository _repository = ReminderRepository();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime? _selectedDate;
  bool _isSaving = false;
  String? _errorMessage;
  bool _titleIsEmpty = true;
  bool _descriptionIsEmpty = true;

  DateTime? get selectedDate => _selectedDate;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  bool get titleIsEmpty => _titleIsEmpty;
  bool get descriptionIsEmpty => _descriptionIsEmpty;

  String get dateDisplay {
    if (_selectedDate == null) return 'Дата: 00/00/0000';
    return 'Дата: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';
  }

  bool get isFormValid {
    return !_titleIsEmpty && !_descriptionIsEmpty && _selectedDate != null;
  }

  CreateReminderViewModel() {
    titleController.addListener(_onTitleChanged);
    descriptionController.addListener(_onDescriptionChanged);
  }

  void _onTitleChanged() {
    _titleIsEmpty = titleController.text.isEmpty;
    notifyListeners();
  }

  void _onDescriptionChanged() {
    _descriptionIsEmpty = descriptionController.text.isEmpty;
    notifyListeners();
  }

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      _selectedDate = picked;
      _errorMessage = null;
      notifyListeners();
    }
  }

  Future<bool> saveReminder(BuildContext context) async {
    if (!isFormValid) return false;

    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.createReminder(
        title: titleController.text.trim(),
        description: descriptionController.text.trim().isEmpty
            ? null
            : descriptionController.text.trim(),
        date: _selectedDate!,
      );

      _isSaving = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void reset() {
    _selectedDate = null;
    _titleIsEmpty = true;
    _descriptionIsEmpty = true;
    _errorMessage = null;
    titleController.clear();
    descriptionController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.removeListener(_onTitleChanged);
    descriptionController.removeListener(_onDescriptionChanged);
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}