import 'package:flutter/material.dart';
import '../../../../shared/widgets/buttons/save_button.dart';
import '../../../../shared/widgets/forms/reminder_form.dart';
import '../../data/repositories/reminder_repository.dart';

class CreateReminderScreen extends StatefulWidget {
  const CreateReminderScreen({super.key});

  @override
  State<CreateReminderScreen> createState() => _CreateReminderScreenState();
}

class _CreateReminderScreenState extends State<CreateReminderScreen> {
  final ReminderRepository _repository = ReminderRepository();

  String _dateDisplay = 'Дата: 00/00/0000';
  DateTime? _selectedDate;

  static const _defaultBackgroundColor = Color(0xFFF3F3F3);
  static const _borderColor = Color(0xFFC6C6C6);
  static const _activeColor = Color(0xFF44E4BF);

  bool _titleIsEmpty = true;
  bool _descriptionIsEmpty = true;
  bool _isSaving = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool get _isFormValid {
    return !_titleIsEmpty &&
        !_descriptionIsEmpty &&
        _selectedDate != null;
  }

  Future<void> _handleSave() async {
    if (!_isFormValid) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final reminder = await _repository.createReminder(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        date: _selectedDate!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Напоминание создано!'),
            backgroundColor: Color(0xFF44E4BF),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: ${e.toString().replaceFirst('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final dateString = '${picked.day}/${picked.month}/${picked.year}';
      setState(() {
        _dateDisplay = dateString;
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новое напоминание'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: ReminderForm(
                  dateDisplay: _dateDisplay,
                  titleIsEmpty: _titleIsEmpty,
                  descriptionIsEmpty: _descriptionIsEmpty,
                  onTitleChanged: (text) {
                    setState(() {
                      _titleIsEmpty = text.isEmpty;
                    });
                  },
                  onDateTap: _selectDate,
                  onDescriptionChanged: (text) {
                    setState(() {
                      _descriptionIsEmpty = text.isEmpty;
                    });
                  },
                  backgroundColor: _defaultBackgroundColor,
                  titleController: _titleController,
                  descriptionController: _descriptionController,
                ),
              ),
            ),
            const SizedBox(height: 12),

            if (_isSaving)
              const Center(child: CircularProgressIndicator())
            else
              SaveButton(
                onPressed: _handleSave,
                backgroundColor: _isFormValid ? _activeColor : _defaultBackgroundColor,
                borderColor: _isFormValid ? _activeColor : _borderColor,
                textColor: _isFormValid ? Colors.white : Colors.black,
                isEnabled: _isFormValid,
              ),
          ],
        ),
      ),
    );
  }
}