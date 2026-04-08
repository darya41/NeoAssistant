import 'package:flutter/material.dart';

class ReminderDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isEditing;
  final VoidCallback onSave;
  final VoidCallback onEdit;
  final VoidCallback onBack;

  const ReminderDetailAppBar({
    super.key,
    required this.isEditing,
    required this.onSave,
    required this.onEdit,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBack,
      ),
      actions: [
        IconButton(
          icon: Icon(
            isEditing ? Icons.save : Icons.edit,
            color: Colors.black,
          ),
          onPressed: isEditing ? onSave : onEdit,
        ),
      ],
      backgroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}