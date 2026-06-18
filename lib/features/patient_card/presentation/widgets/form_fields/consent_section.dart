import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class ConsentSectionWidget extends StatelessWidget {
  const ConsentSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'С законным представителем ребёнка проведено устное информирование о выполнении простых медицинских вмешательств согласно Постановлению МЗ РБ от 31.05.2011 г. №49 «Об установлении перечня простых медицинских вмешательств».',
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.green, size: 20),
                SizedBox(width: 8),
                Text(
                  'УСТНОЕ СОГЛАСИЕ ПОЛУЧЕНО',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.green,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}