import 'package:flutter/material.dart';

import '../../domain/entities/protocol.dart';
import '../view_model/protocol_detail_viewmodel.dart';
import '../widget/content_section.dart';
import '../widget/error.dart';
import '../widget/empty_content.dart';

class ProtocolDetailScreen extends StatefulWidget {
  final Protocol protocol;

  const ProtocolDetailScreen({super.key, required this.protocol});

  @override
  State<ProtocolDetailScreen> createState() => _ProtocolDetailScreenState();
}

class _ProtocolDetailScreenState extends State<ProtocolDetailScreen> {
  late ProtocolDetailViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ProtocolDetailViewModel();
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.loadDetail(widget.protocol.id!);
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.protocol.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: false,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.error != null) {
      return Error(
        error: _viewModel.error!,
        onRetry: () => _viewModel.retry(),
      );
    }

    final detail = _viewModel.detail;
    if (detail?.content == null || detail!.content.isEmpty) {
      return const EmptyContent();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.protocol.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          ...detail.content.entries.map((entry) {
            return ContentSection(
              sectionKey: entry.key,
              value: entry.value,
            );
          }),
        ],
      ),
    );
  }
}