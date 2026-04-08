import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorView({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 16),
          Text(errorMessage),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }
}