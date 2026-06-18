import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../protocol/domain/entities/tech_level.dart';
import '../view_models/tech_level_viewmodel.dart';

class TechLevelScreen extends StatelessWidget {
  const TechLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TechLevelViewModel(),
      child: const _TechLevelContent(),
    );
  }
}

class _TechLevelContent extends StatelessWidget {
  const _TechLevelContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TechLevelViewModel>();
    final isLoading = viewModel.isLoading;
    final isSaving = viewModel.isSaving;
    final currentLevel = viewModel.currentLevel;
    final allLevels = viewModel.allLevels;
    final error = viewModel.error;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Технологический уровень'),
        centerTitle: true,
        backgroundColor: AppColors.brand_40,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!isLoading)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => viewModel.refresh(),
            ),
        ],
      ),
      body: Stack(
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : error != null && allLevels.isEmpty
              ? _buildErrorWidget(error, viewModel)
              : _buildContent(context, viewModel, currentLevel, allLevels, isSaving),
        ],
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      TechLevelViewModel viewModel,
      TechLevel? currentLevel,
      List<TechLevel> allLevels,
      bool isSaving,
      ) {
    return Column(
      children: [
        _buildCurrentLevelCard(currentLevel, isSaving),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: [
              const Text(
                'Выберите уровень вашей медицинской организации:',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ...allLevels.map((level) => _buildLevelCard(
                level,
                isSelected: currentLevel?.id == level.id,
                isDisabled: isSaving,
                onSelect: () => _selectLevel(context, viewModel, level),
              )),
              const SizedBox(height: 24),
              _buildHintCard(currentLevel, viewModel),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentLevelCard(TechLevel? currentLevel, bool isSaving) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.brand_40.withOpacity(0.1),
            AppColors.brand_40.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.brand_40.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          if (isSaving)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.medical_services, size: 20, color: AppColors.brand_40),
              const SizedBox(width: 8),
              Text(
                'Текущий уровень',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            currentLevel?.name ?? 'Не выбран',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.brand_40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard(
      TechLevel level, {
        required bool isSelected,
        required bool isDisabled,
        required VoidCallback onSelect,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.brand_40.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.brand_40 : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onSelect,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.brand_40
                          : (isDisabled ? Colors.grey[300]! : Colors.grey[400]!),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.brand_40,
                      ),
                    ),
                  )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            level.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              color: isSelected
                                  ? AppColors.brand_40
                                  : (isDisabled ? Colors.grey[400] : Colors.black),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        level.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDisabled ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHintCard(TechLevel? currentLevel, TechLevelViewModel viewModel) {
    final nextLevel = viewModel.getNextLevel();

    if (currentLevel == null || nextLevel == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Для доступа к материалам уровня "${nextLevel.name}" необходимо повысить ваш технологический уровень.',
              style: TextStyle(fontSize: 12, color: Colors.blue[700]),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _selectLevel(
      BuildContext context,
      TechLevelViewModel viewModel,
      TechLevel level,
      ) async {
    if (viewModel.currentLevel?.id == level.id) return;

    await viewModel.saveLevel(level);
  }

  Widget _buildErrorWidget(String error, TechLevelViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 16),
          Text('Ошибка: $error'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => viewModel.refresh(),
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }
}