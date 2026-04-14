import 'package:flutter/material.dart';
import '../../../main/presentation/widgets/navigation/analytics_bottom_bar.dart';
import '../view_models/calculators_viewmodel.dart';
import '../widgets/calculator_card.dart';
import 'calculator_detail_screen.dart';

class CalculatorsScreen extends StatefulWidget {
  const CalculatorsScreen({super.key});

  @override
  State<CalculatorsScreen> createState() => _CalculatorsScreenState();
}

class _CalculatorsScreenState extends State<CalculatorsScreen> {
  late final CalculatorsViewModel _viewModel;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _viewModel = CalculatorsViewModel();
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _handleSearch(String query) {
    _viewModel.searchCalculators(query);
  }

  void _clearSearch() {
    _searchController.clear();
    _viewModel.clearSearch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Калькуляторы'),
        backgroundColor: const Color(0xFF44E4BF),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: _buildSearchBar(),
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: const AnalyticsBottomBar(
        currentIndex: 2,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            hintText: 'Поиск калькуляторов...',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
              onPressed: _clearSearch,
            )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
          onChanged: _handleSearch,
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_viewModel.isLoading || _viewModel.isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(_viewModel.errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _viewModel.retry(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF44E4BF),
              ),
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (_viewModel.calculators.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _viewModel.searchQuery.isNotEmpty
                  ? 'Ничего не найдено по запросу "${_viewModel.searchQuery}"'
                  : 'Нет доступных калькуляторов',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            if (_viewModel.searchQuery.isNotEmpty)
              TextButton(
                onPressed: _viewModel.clearSearch,
                child: const Text('Очистить поиск'),
              ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _viewModel.calculators.length,
      itemBuilder: (context, index) {
        final calculator = _viewModel.calculators[index];
        return CalculatorCard(
          calculator: calculator,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CalculatorDetailScreen(
                  calculator: calculator,
                ),
              ),
            );
          },
        );
      },
    );
  }
}