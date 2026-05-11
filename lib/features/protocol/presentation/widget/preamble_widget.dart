import 'package:flutter/material.dart';
import '../../domain/entities/protocol_document.dart';

class PreambleWidget extends StatelessWidget {
  final ProtocolDocument document;
  final bool isExpanded;
  final VoidCallback onTap;

  const PreambleWidget({
    super.key,
    required this.document,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formattedLegalBasis = _formatLegalBasis(document.legalBasis);
    final approvingList = _getApprovingList(document.approving);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              children: [
                Icon(
                  isExpanded ? Icons.expand_more : Icons.chevron_right,
                  size: 20,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Преамбула',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 28, right: 8, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Постановление ${document.author}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_formatDate(document.adoptionDate)} № ${document.number}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 12),
                _buildText('Об утверждении клинического протокола'),
                const SizedBox(height: 12),
                if (formattedLegalBasis.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: formattedLegalBasis.map((line) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),

                      child: Text(
                        line,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.grey[700],
                        ),
                      ),
                    )).toList(),
                  ),
                const SizedBox(height: 12),
                if (document.signedBy != null && document.signedBy!.isNotEmpty)
                  Row(
                    children: [
                      _buildText('Министр'),
                      const SizedBox(width: 120),
                      _buildText(document.signedBy!),
                    ],
                  ),
                const SizedBox(height: 16),
                if (approvingList.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildText('СОГЛАСОВАНО',fontSize: 12.0,fontWeight: FontWeight.w600,
                        color: Colors.grey[700]!,),
                      const SizedBox(height: 8),
                      ...approvingList.map((org) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          org.trim(),
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.4,
                            color: Colors.grey[600],
                          ),
                        ),
                      )),
                    ],
                  ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(width: 120),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildText('УТВЕРЖДЕНО'),
                          const SizedBox(height: 10),
                          _buildText('Постановление ${document.author}'),
                          const SizedBox(height: 2),
                          _buildText('${_formatDate(document.adoptionDate)} № ${document.number}'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                _buildText('КЛИНИЧЕСКИЙ ПРОТОКОЛ'),
                const SizedBox(height: 4),
                _buildText('«${document.title}»'),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildText( String text, { double fontSize = 14,
        FontWeight fontWeight = FontWeight.w500, Color color = Colors.black,
      }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
      softWrap: true,
    );
  }

  List<String> _formatLegalBasis(String? legalBasis) {
    if (legalBasis == null || legalBasis.isEmpty) return [];

    String text = legalBasis;

    text = text.replaceAll(RegExp(r'(\s+)(\d+\.)'), r'\n$2');
    text = text.replaceAll(RegExp(r'^(\d+\.)'), r'\n$1');

    final lines = text.split('\n');

    final result = <String>[];
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isNotEmpty) {
        result.add(trimmed);
      }
    }

    return result;
  }

  List<String> _getApprovingList(String? approving) {
    if (approving == null || approving.isEmpty) return [];

    final parts = approving.split(',');

    final result = <String>[];
    for (final part in parts) {
      final trimmed = part.trim();
      if (trimmed.isNotEmpty) {
        result.add(trimmed);
      }
    }

    return result;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}