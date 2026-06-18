import 'package:flutter/material.dart';
import '../../domain/entities/mkb.dart';

class MkbBreadcrumb extends StatelessWidget {
  final List<MkbCategory> selectedPath;
  final VoidCallback onBack;
  final Function(MkbCategory) onNavigateTo;

  const MkbBreadcrumb({
    super.key,
    required this.selectedPath,
    required this.onBack,
    required this.onNavigateTo,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedPath.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.white),
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: onBack,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back, size: 16),
                      SizedBox(width: 4),
                      Text('Назад'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              ..._buildBreadcrumbItems(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBreadcrumbItems() {
    final List<Widget> crumbs = [];

    for (int i = 0; i < selectedPath.length; i++) {
      final category = selectedPath[i];

      crumbs.add(
        GestureDetector(
          onTap: () => onNavigateTo(category),
          child: Text(
            category.code,
            style: TextStyle(
              fontSize: 14,
              color: i == selectedPath.length - 1 ? Colors.black : Colors.blue,
              fontWeight: i == selectedPath.length - 1 ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      );

      if (i < selectedPath.length - 1) {
        crumbs.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(Icons.chevron_right, size: 16, color: Colors.grey[500]),
          ),
        );
      }
    }
    return crumbs;
  }
}