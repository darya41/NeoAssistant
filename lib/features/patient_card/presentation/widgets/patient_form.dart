import 'package:flutter/material.dart';

class PatientForm {
  static Container searchField(
      TextEditingController motherFioController,
      VoidCallback onTextChange,
      Color defaultBackgroundColor,
      Color borderColor,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: defaultBackgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: motherFioController,
              onChanged: (text) => onTextChange(),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'ФИО матери',
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => print('Добавить новую мать'),
          ),
        ],
      ),
    );
  }

  static GestureDetector dateField(
      String dateDisplay,
      VoidCallback onTap,
      Color defaultBackgroundColor,
      Color borderColor,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: defaultBackgroundColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today),
            const SizedBox(width: 8),
            Text(dateDisplay),
          ],
        ),
      ),
    );
  }

  static GestureDetector timeField(
      String timeDisplay,
      VoidCallback onTap,
      Color defaultBackgroundColor,
      Color borderColor,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: defaultBackgroundColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time),
            const SizedBox(width: 8),
            Text(timeDisplay),
          ],
        ),
      ),
    );
  }

  // 🔥 ИСПРАВЛЕНО: теперь в сером квадрате
  static Container historyField(
      TextEditingController historyNumberController,
      Color defaultBackgroundColor,
      Color borderColor,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: defaultBackgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: historyNumberController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: 'Номер истории',
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }

  // 🔥 ИСПРАВЛЕНО: теперь в сером квадрате
  static Container heightField(
      TextEditingController childHeightController,
      Color defaultBackgroundColor,
      Color borderColor,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: defaultBackgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: childHeightController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: 'Рост ребёнка (сантиметров)',
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }

  // 🔥 ИСПРАВЛЕНО: теперь в сером квадрате
  static Container weightField(
      TextEditingController childWeightController,
      Color defaultBackgroundColor,
      Color borderColor,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: defaultBackgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: childWeightController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: 'Вес ребёнка (грамм)',
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }

  static Column genderField({
    required String selectedGender,
    required VoidCallback onMaleSelected,
    required VoidCallback onFemaleSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Пол ребёнка:'),
        const SizedBox(height: 8),
        Row(
          children: [
            Radio<String>(
              value: 'мужской',
              groupValue: selectedGender,
              onChanged: (value) {
                if (value == 'мужской') onMaleSelected();
              },
            ),
            const Text('Мужской'),
            const SizedBox(width: 16),
            Radio<String>(
              value: 'женский',
              groupValue: selectedGender,
              onChanged: (value) {
                if (value == 'женский') onFemaleSelected();
              },
            ),
            const Text('Женский'),
          ],
        ),
      ],
    );
  }
}