import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/mkb.dart';
import 'mkb_category_card.dart';
import 'mkb_breadcrumb.dart';
import '../view_model/mkb_categories_viewmodel.dart';

class MkbCategoriesList extends StatelessWidget {
  const MkbCategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MkbCategoriesViewModel(),
      child: const _MkbCategoriesListContent(),
    );
  }
}

class _MkbCategoriesListContent extends StatelessWidget {
  const _MkbCategoriesListContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MkbCategoriesViewModel>();
    final mkbCategories = viewModel.mkbCategories;
    final isLoading = viewModel.isLoading;
    final error = viewModel.error;
    final selectedPath = viewModel.selectedPath;
    final canGoBack = viewModel.canGoBack;

    return Column(
      children: [
        MkbBreadcrumb(
          selectedPath: selectedPath,
          onBack: () => viewModel.goBack(),
          onNavigateTo: (category) => _navigateToLevel(viewModel, category),
        ),
        Expanded(
          child: _buildContent(
            context,
            viewModel,
            mkbCategories,
            isLoading,
            error,
            canGoBack,
          ),
        ),
      ],
    );
  }

  void _navigateToLevel(MkbCategoriesViewModel viewModel, MkbCategory category) {
    viewModel.navigateToLevel(category);
  }

  Widget _buildContent(
      BuildContext context,
      MkbCategoriesViewModel viewModel,
      List<MkbCategory> mkbCategories,
      bool isLoading,
      String? error,
      bool canGoBack,
      ) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return _buildErrorWidget(error, viewModel);
    }

    if (mkbCategories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Нет дочерних элементов',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            if (canGoBack) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => viewModel.goBack(),
                child: const Text('Вернуться назад'),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: mkbCategories.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final category = mkbCategories[index];
        return MkbCategoryCard(
          category: category,
          onTap: () => _onCategoryTap(context, viewModel, category),
        );
      },
    );
  }

  void _onCategoryTap(
      BuildContext context,
      MkbCategoriesViewModel viewModel,
      MkbCategory category,
      ) {
    if (category.level < 4) {
      viewModel.loadChildren(category);
    }
  }

  Widget _buildErrorWidget(String error, MkbCategoriesViewModel viewModel) {
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