import 'package:flutter/material.dart';
import 'package:neo_friend/features/protocol/presentation/page/protocols_sort_list_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/mkb.dart';

class MkbCategoryCard extends StatelessWidget {
  final MkbCategory category;
  final VoidCallback? onTap;
  final int? techLevelId;

  const MkbCategoryCard({
    super.key,
    required this.category,
    this.onTap,
    this.techLevelId,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          if (onTap != null) {
            onTap!();
          } else {
            final mkbId = category.id;

            final techLevelId = await TokenStorage.getTechLevelId();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProtocolsSortListScreen(
                  sourceId: mkbId,
                  sourceName: category.title,
                  sourceType: ProtocolsSourceType.mkb,
                  techLevelId: techLevelId,
                ),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.neutral_0,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.neutral_5),
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
                    color: AppColors.neutral_90,
                    height: 1.3,
                  ),
                  maxLines: 8,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.neutral_50,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}