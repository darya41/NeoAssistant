import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class RemindersAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isEditing;
  final VoidCallback onToggleSort;
  final VoidCallback onToggleEditing;

  const RemindersAppBar({
    super.key,
    required this.isEditing,
    required this.onToggleSort,
    required this.onToggleEditing,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Сначала новые'),
          IconButton(
            icon: const Icon(Icons.arrow_drop_down),
            onPressed: onToggleSort,
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: Icon(
              isEditing ? Icons.save : Icons.edit,
              color: Colors.black,
            ),
            onPressed: onToggleEditing,
          ),
        ],
      ),
      backgroundColor: AppColors.brand_40,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}