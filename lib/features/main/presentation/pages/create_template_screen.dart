import 'package:flutter/material.dart';

import '../../../../shared/widgets/buttons/continue_button.dart';
import '../../../reminders/presentation/widgets/reminder_form.dart';

class CreateTemplateScreen extends StatefulWidget {
  const CreateTemplateScreen({super.key});

  @override
  State<CreateTemplateScreen> createState() => _CreateTemplateScreenState();
}

class _CreateTemplateScreenState extends State<CreateTemplateScreen> {
  String _dateDisplay = 'Дата: 00/00/0000';
  static const _defaultBackgroundColor = Color(0xFFF3F3F3);
  static const _borderColor = Color(0xFFC6C6C6);
  static const _activeColor = Color(0xFF44E4BF);

  bool _titleIsEmpty = true;
  bool _descriptionIsEmpty = true;

  bool get _isFormValid {
    return !_titleIsEmpty &&
        !_descriptionIsEmpty &&
        _dateDisplay != 'Дата: 00/00/0000';
  }

  void _handleSave() {
    // логика сохранения
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Новый шаблон'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
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
              ),
            ),
            SizedBox(height: 12),

            ContinueButton(
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