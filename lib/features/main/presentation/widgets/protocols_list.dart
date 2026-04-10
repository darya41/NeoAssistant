import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../protocol/domain/entities/protocol.dart';
import '../../../protocol/presentation/page/protocol_detail_screen.dart';
import '../view_models/protocol_search_viewmodel.dart';

class ProtocolsList extends StatelessWidget {
  const ProtocolsList({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProtocolSearchViewModel>();
    final protocols = viewModel.filteredProtocols;
    final isLoading = viewModel.isLoading;
    final error = viewModel.error;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
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

    if (protocols.isEmpty) {
      return const Center(
        child: Text('Нет доступных протоколов'),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: protocols.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final protocol = protocols[index];
        return _buildProtocolCard(protocol, context);
      },
    );
  }

  Widget _buildProtocolCard(Protocol protocol, BuildContext context) {
    return InkWell(
      onTap: () {
        _navigateToDetail(protocol, context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            protocol.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            protocol.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
            height: 20,
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(Protocol protocol, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProtocolDetailScreen(protocol: protocol),
      ),
    );
  }
}