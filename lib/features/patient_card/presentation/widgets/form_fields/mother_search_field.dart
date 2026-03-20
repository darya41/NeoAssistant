import 'package:flutter/material.dart';
import '../../pages/add_mother_screen.dart';

class MotherSearchField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTextChange;
  final VoidCallback? onMotherAdded;

  static const _defaultBackgroundColor = Color(0xFFF3F3F3);
  static const _borderColor = Color(0xFFC6C6C6);

  const MotherSearchField({
    super.key,
    required this.controller,
    required this.onTextChange,
    this.onMotherAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _defaultBackgroundColor,
        border: Border.all(color: _borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
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
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddMotherScreen()),
              );
              if (result != null && onMotherAdded != null) {
                onMotherAdded!();
              }
            },
          ),
        ],
      ),
    );
  }
}