import 'package:flutter/material.dart';
import '../../../../models/protocol.dart';

class ProtocolsList extends StatelessWidget {
  const ProtocolsList({super.key});

  static final List<Protocol> _protocols = [
    Protocol(
      title: 'Лечение гипербилирубинемии',
      description: 'Желтуха новорожденных возникает в результате повышенного уровня билирубина. Факторы риска включают...',
      hasPDF: true,
      hasDOC: false,
    ),
    Protocol(
      title: 'Протокол обследования',
      description: 'Краткое описание протокола обследования пациента.',
      hasPDF: true,
      hasDOC: true,
    ),
    Protocol(
      title: 'Респираторная поддержка',
      description: 'Протокол проведения ИВЛ и неинвазивной вентиляции легких у новорожденных.',
      hasPDF: true,
      hasDOC: false,
    ),
    Protocol(
      title: 'Парентеральное питание',
      description: 'Расчет и проведение парентерального питания для недоношенных детей.',
      hasPDF: false,
      hasDOC: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
    return Column(
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
        ),
        const SizedBox(height: 12),
        _buildFileTags(protocol),
        const Divider(
          color: Colors.grey,
          thickness: 0.5,
          height: 20,
        ),
      ],
    );
  }

  Widget _buildFileTags(Protocol protocol) {
    final List<Widget> tags = [];

    if (protocol.hasPDF) {
      tags.add(_buildFileChip('PDF', Colors.blue));
    }

    if (protocol.hasPDF && protocol.hasDOC) {
      tags.add(const SizedBox(width: 8));
    }

    if (protocol.hasDOC) {
      tags.add(_buildFileChip('DOC', Colors.green));
    }

    return Row(children: tags);
  }

  Widget _buildFileChip(String label, MaterialColor color) {
    return Chip(
      label: Text(label),
      backgroundColor: color[100],
      labelStyle: TextStyle(color: color[800]),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}