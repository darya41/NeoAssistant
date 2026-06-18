import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../main/presentation/view_models/protocol_search_viewmodel.dart';
import '../../../protocol/presentation/page/protocols_sort_list_screen.dart';
import '../../domain/entities/mkb.dart';
import 'mkb_category_card.dart';
import 'mkb_breadcrumb.dart';
import '../view_model/mkb_categories_viewmodel.dart';

class MkbCategoriesList extends StatefulWidget {
  const MkbCategoriesList({super.key});

  @override
  State<MkbCategoriesList> createState() => _MkbCategoriesListState();
}

class _MkbCategoriesListState extends State<MkbCategoriesList> {
  late MkbCategoriesViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = MkbCategoriesViewModel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final searchViewModel = context.watch<ProtocolSearchViewModel>();
    final currentQuery = searchViewModel.mkbSearchQuery;

    if (_viewModel.currentSearchQuery != currentQuery) {
      _viewModel.updateSearchQuery(currentQuery);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: const _MkbCategoriesListContent(),
    );
  }
}

class _MkbCategoriesListContent extends StatelessWidget {
  const _MkbCategoriesListContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MkbCategoriesViewModel>();

    return Column(
      children: [
        if (!viewModel.isSearching)
          MkbBreadcrumb(
            selectedPath: viewModel.selectedPath,
            onBack: viewModel.goBack,
            onNavigateTo: viewModel.navigateToLevel,
          ),
        Expanded(child: _buildContent(viewModel)),
      ],
    );
  }

  Widget _buildContent(MkbCategoriesViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.error != null) {
      return _buildErrorWidget(viewModel);
    }

    if (viewModel.mkbCategories.isEmpty) {
      return _buildEmptyWidget(viewModel);
    }

    return _buildListView(viewModel);
  }

  Widget _buildListView(MkbCategoriesViewModel viewModel) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: viewModel.mkbCategories.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final category = viewModel.mkbCategories[index];
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
      if (viewModel.isSearching) {
        viewModel.updateSearchQuery('');
      }
      viewModel.loadChildren(category);
    }
    else {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProtocolsSortListScreen(
            sourceId: category.id,
            sourceName: '${category.code} ${category.title}',
            sourceType: ProtocolsSourceType.mkb,
          ),
        ),
      );
    }
  }

  Widget _buildEmptyWidget(MkbCategoriesViewModel viewModel) {
    final isSearching = viewModel.isSearching;
    final searchQuery = viewModel.currentSearchQuery;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off : Icons.folder_outlined,
            size: 64,
            color: AppColors.neutral_50,
          ),
          const SizedBox(height: 16),
          Text(
            isSearching
                ? 'Ничего не найдено по запросу "$searchQuery"'
                : 'Нет дочерних элементов',
            style: TextStyle(fontSize: 16, color: AppColors.neutral_50),
            textAlign: TextAlign.center,
          ),
          if (isSearching) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => viewModel.updateSearchQuery(''),
              child: const Text('Очистить поиск'),
            ),
          ] else if (viewModel.canGoBack) ...[
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

  Widget _buildErrorWidget(MkbCategoriesViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 16),
          Text('Ошибка: ${viewModel.error}'),
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