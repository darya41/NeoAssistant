import 'package:flutter/material.dart';
import 'package:neo_friend/features/main/presentation/pages/home_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../protocol/data/repositories/protocol_repository.dart';
import '../../../protocol/domain/entities/protocol.dart';

class ProtocolsList extends StatefulWidget {
  const ProtocolsList({super.key});

  @override
  State<ProtocolsList> createState() => _ProtocolsListState();
}

class _ProtocolsListState extends State<ProtocolsList> {
  final ProtocolRepository _protocolRepository = ProtocolRepository();
  List<Protocol> _protocols = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProtocols();
  }

  Future<void> _loadProtocols() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final protocols = await _protocolRepository.getAllProtocols();
      setState(() {
        _protocols = protocols;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text('Ошибка: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProtocols,
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (_protocols.isEmpty) {
      return const Center(
        child: Text('Нет доступных протоколов'),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: _protocols.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final protocol = _protocols[index];
        return _buildProtocolCard(protocol);
      },
    );
  }

  Widget _buildProtocolCard(Protocol protocol) {
    return InkWell(
      onTap: () {
        _navigateToDetail(protocol);
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

  void _navigateToDetail(Protocol protocol) {
    Navigator.push(
      context,
      MaterialPageRoute(
        //builder: (context) => ProtocolDetailScreen(protocol: protocol),
          builder: (context) => HomeScreen(title: 'aaaaa',),
      ),
    );
  }
}