import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/medication.dart';
import '../page/medication_protocols_screen.dart';

class MedicationCard extends StatelessWidget {
  final Medication medication;
  final VoidCallback? onTap;

  const MedicationCard({
    super.key,
    required this.medication,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicationProtocolsScreen(
              medicationId: medication.id,
              medicationName: medication.inn,
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
                Expanded(
                  child: Text(
                    medication.inn,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.neutral_90,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.neutral_50,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 4),

            if (medication.brandName != null && medication.brandName!.isNotEmpty) ...[
              Text(
                medication.brandName!,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.neutral_50,
                ),
              ),
            ],
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (medication.dosageForm != null && medication.dosageForm!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      medication.dosageForm!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blueColor,
                      ),
                    ),
                  ),
                if (medication.drugClass != null && medication.drugClass!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      medication.drugClass!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.green[700],
                      ),
                    ),
                  ),
              ],
            ),

            if (medication.strength != null && medication.strength!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.science, size: 16, color: AppColors.neutral_50),
                  const SizedBox(width: 8),
                  Text(
                    medication.strength!,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.neutral_50,
                    ),
                  ),
                ],
              ),
            ],

            if (medication.specialNotes != null && medication.specialNotes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, size: 16, color: AppColors.yellowColor ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        medication.specialNotes!,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.yellowColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}