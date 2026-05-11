import '../../domain/entities/protocol_document.dart';
import '../../domain/entities/protocol_hierarchy.dart';
import '../../domain/entities/protocol_list_item.dart';
import '../../domain/utils/title_cleaner.dart';
import '../../domain/utils/tree_builder.dart';
import '../services/protocol_service.dart';

class ProtocolRepository {
  final ProtocolService _service = ProtocolService();

  Future<List<ProtocolDocument>> getAllProtocolDocuments() async {
    try {
      final response = await _service.getAllProtocolDocuments();

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка получения списка протоколов');
      }

      final data = response['data'];
      if (data is! List) {
        throw Exception('Неверный формат данных');
      }

      return data.map((json) => ProtocolDocument.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProtocolListItem>> getProtocolFlatList() async {
    try {
      final documents = await getAllProtocolDocuments();
      final List<ProtocolListItem> items = [];

      for (final doc in documents) {
        final hierarchy = await getProtocolHierarchy(doc.id);
        final flatItems = _flattenHierarchy(doc, hierarchy);
        items.addAll(flatItems);
      }

      return items;
    } catch (e) {
      rethrow;
    }
  }

  List<ProtocolListItem> _flattenHierarchy(
      ProtocolDocument doc,
      List<ProtocolHierarchy> hierarchy,
      ) {
    final List<ProtocolListItem> result = [];

    void traverse(List<ProtocolHierarchy> items) {
      for (final item in items) {
        final hasDirectChildren = item.children.isNotEmpty;
        final hasGrandChildren = TreeBuilder.hasGrandchildren(item);
        final isExcluded = TitleCleaner.isExcludedChapter(item.title, item.level);

        final shouldAdd = hasDirectChildren && !hasGrandChildren && !isExcluded;
        final cleanedTitle = TitleCleaner.clean(item.title);

        if (shouldAdd) {
          result.add(ProtocolListItem(
            protocolDocumentId: doc.id,
            protocolTitle: doc.title,
            hierarchyId: item.id,
            hierarchyTitle: cleanedTitle,
            level: item.level,
            parentId: item.parentId,
            content: item.content,
          ));
        }

        if (item.children.isNotEmpty) {
          traverse(item.children);
        }
      }
    }

    traverse(hierarchy);
    return result;
  }

  Future<List<ProtocolHierarchy>> getProtocolHierarchy(int protocolDocumentId) async {
    try {
      final response = await _service.getProtocolHierarchy(protocolDocumentId);

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка получения иерархии протокола');
      }

      final data = response['data'];
      if (data is! List) {
        throw Exception('Неверный формат данных');
      }

      final items = data.map((json) => ProtocolHierarchy.fromJson(json)).toList();
      return TreeBuilder.buildTree(items);
    } catch (e) {
      rethrow;
    }
  }

  Future<ProtocolDocument?> getProtocolDocumentById(int protocolDocumentId) async {
    try {
      final response = await _service.getProtocolDocumentById(protocolDocumentId);

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка получения документа протокола');
      }

      final data = response['data'];
      if (data == null) {
        return null;
      }

      return ProtocolDocument.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }
}