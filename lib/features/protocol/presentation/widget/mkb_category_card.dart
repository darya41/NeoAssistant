import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/mkb.dart';
import '../view_model/mkb_categories_viewmodel.dart';

class MkbCategoryCard extends StatelessWidget {
  final MkbCategory category;
  final VoidCallback? onTap;

  const MkbCategoryCard({
    super.key,
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasChildren = category.level < 4;

    return InkWell(
      onTap: onTap ?? () {
        final viewModel = context.read<MkbCategoriesViewModel>();
        if (hasChildren) {
          viewModel.loadChildren(category);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.brand_40.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                category.code,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.brand_40,
                ),
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Text(
                category.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 1.3,
                ),
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}