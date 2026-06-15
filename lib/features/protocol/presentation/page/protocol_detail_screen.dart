import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/protocol_document.dart';
import '../view_model/protocol_detail_viewmodel.dart';
import '../../domain/entities/protocol_hierarchy.dart';
import '../widget/preamble_widget.dart';

class ProtocolDetailScreen extends StatelessWidget {
  final int protocolDocumentId;
  final int? selectedHierarchyId;

  const ProtocolDetailScreen({
    super.key,
    required this.protocolDocumentId,
    this.selectedHierarchyId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProtocolDetailViewModel(
        protocolDocumentId: protocolDocumentId,
        selectedHierarchyId: selectedHierarchyId,
      ),
      child: const _ProtocolDetailContent(),
    );
  }
}

class _ProtocolDetailContent extends StatelessWidget {
  const _ProtocolDetailContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProtocolDetailViewModel>();
    final isLoading = viewModel.isLoading;
    final error = viewModel.error;
    final contentItems = viewModel.displayContentItems;
    final document = viewModel.document;
    final isLoadingItem = viewModel.isLoadingItem;

    return Scaffold(
      appBar: AppBar(
        title: Text(document?.title ?? 'Содержание'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? _buildErrorWidget(error, viewModel)
          : _buildContent(document, viewModel, contentItems, isLoadingItem, context),
    );
  }

  Widget _buildContent(
      ProtocolDocument? document,
      ProtocolDetailViewModel viewModel,
      List<ProtocolHierarchy> contentItems,
      int? isLoadingItem,
      BuildContext context,
      ) {
    final List<Widget> items = [];

    if (document != null) {
      items.add(
        PreambleWidget(
          document: document,
          isExpanded: viewModel.isPreambleExpanded,
          onTap: () => viewModel.togglePreamble(),
        ),
      );
      items.add(const SizedBox(height: 16));
    }

    items.add(
      Padding(
        padding: const EdgeInsets.only(left: 8, bottom: 12),
        child: Text(
          'ГЛАВЫ',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
            letterSpacing: 1,
          ),
        ),
      ),
    );

    for (final chapter in viewModel.chapters) {
      final isSelected = viewModel.selectedItemId == chapter.id;
      final isExpanded = viewModel.expandedChapters.contains(chapter.id);
      final isLoading = isLoadingItem == chapter.id;

      items.add(
        _buildChapterCard(
          chapter: chapter,
          isSelected: isSelected,
          isExpanded: isExpanded,
          isLoading: isLoading,
          onTap: () => viewModel.selectItem(chapter.id),
        ),
      );
      items.add(const SizedBox(height: 8));
    }

    if (contentItems.isNotEmpty &&
        viewModel.selectedItemId != null &&
        viewModel.expandedChapters.contains(viewModel.selectedItemId)) {

      items.add(const SizedBox(height: 24));
      items.add(
        const Divider(thickness: 1, height: 1),
      );
      items.add(const SizedBox(height: 16));

      items.add(
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            'СОДЕРЖАНИЕ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              letterSpacing: 1,
            ),
          ),
        ),
      );

      for (int i = 0; i < contentItems.length; i++) {
        final item = contentItems[i];
        items.add(_buildContentItem(item, 0));
        if (i < contentItems.length - 1) {
          items.add(const SizedBox(height: 16));
        }
      }
    } else if (viewModel.selectedItemId != null &&
        !viewModel.expandedChapters.contains(viewModel.selectedItemId)) {
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: items,
    );
  }

  Widget _buildChapterCard({
    required ProtocolHierarchy chapter,
    required bool isSelected,
    required bool isExpanded,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: Colors.blue.shade300, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.shade50 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: isLoading
                    ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isSelected ? Colors.blue : Colors.grey,
                    ),
                  ),
                )
                    : Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: isSelected ? Colors.blue : Colors.grey.shade700,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chapter.title ?? 'Без названия',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected ? Colors.blue.shade700 : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLoading)
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.grey.shade600,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentItem(ProtocolHierarchy item, int indentLevel) {
    final hasContent = item.content != null && item.content!.isNotEmpty;
    final isRoot = item.level == 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: (indentLevel * 18.0)),
          child: Text(
            item.title ?? 'Без названия',
            style: TextStyle(
              fontSize: isRoot ? 18 : 16,
              fontWeight: isRoot ? FontWeight.bold : FontWeight.w600,
              color: isRoot ? Colors.blue.shade900 : Colors.black87,
              height: 1.4,
            ),
          ),
        ),

        const SizedBox(height: 8),

        if (hasContent)
          Padding(
            padding: EdgeInsets.only(
              left: (indentLevel * 16.0) + 8,
              right: 16,
              bottom: 12,
            ),
            child: Text(
              item.content!,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ),


        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildErrorWidget(String error, ProtocolDetailViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text('Ошибка: $error', textAlign: TextAlign.center),
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