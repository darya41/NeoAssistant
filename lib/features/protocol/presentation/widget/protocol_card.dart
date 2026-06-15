import 'package:flutter/material.dart';
import 'package:neo_friend/core/constants/app_colors.dart';
import '../../domain/entities/protocol_list_item.dart';
import '../page/protocol_detail_screen.dart';

class ProtocolCard extends StatelessWidget {
  final ProtocolListItem item;

  const ProtocolCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () async => _navigateToDetail(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: item.protocolTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.neutral_90,
                      ),
                    ),
                    TextSpan(
                      text: ': ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: AppColors.neutral_50,
                        height: 1.5,
                      ),
                    ),
                    TextSpan(
                      text: item.hierarchyTitle,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: AppColors.neutral_60,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProtocolDetailScreen(
          protocolDocumentId: item.protocolDocumentId,
          selectedHierarchyId: item.hierarchyId,
        ),
      ),
    );
  }
}