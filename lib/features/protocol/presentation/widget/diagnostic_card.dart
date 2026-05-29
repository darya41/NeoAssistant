import 'package:flutter/material.dart';
import 'package:neo_friend/features/protocol/presentation/page/protocols_sort_list_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/diagnostic_test.dart';

class DiagnosticCard extends StatelessWidget {
  final DiagnosticTest diagnostic;
  final VoidCallback? onTap;

  const DiagnosticCard({
    super.key,
    required this.diagnostic,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProtocolsSortListScreen(
              sourceId: diagnostic.id,
              sourceName: diagnostic.name,
              sourceType: ProtocolsSourceType.diagnostic,
            ),
          ),
        );
      },
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getTypeColor(diagnostic.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    diagnostic.type,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getTypeColor(diagnostic.type),
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.neutral_50,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              diagnostic.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.neutral_90,
              ),
            ),
            if (diagnostic.description != null && diagnostic.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                diagnostic.description!,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.neutral_60,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'лабораторный':
        return Colors.blue;
      case 'инструментальный':
        return Colors.green;
      case 'функциональный':
        return Colors.orange;
      case 'визуализационный':
        return Colors.teal;
      default:
        return AppColors.brand_40;
    }
  }
}