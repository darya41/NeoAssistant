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

  Future<ProtocolHierarchy> getFullBranch(int hierarchyId) async {
    try {
      final response = await _service.getFullBranch(hierarchyId);

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка получения ветки иерархии');
      }

      final data = response['data'];
      if (data == null) {
        throw Exception('Данные не найдены');
      }

      List<dynamic> itemsList;

      if (data is List) {
        itemsList = data;
      } else if (data is Map && data['data'] is List) {
        itemsList = data['data'];
      } else {
        final item = ProtocolHierarchy.fromJson(data);
        if (data['children'] != null && data['children'] is List) {
          final parsedChildren = _parseChildrenFromJson(data['children']);
          return item.copyWith(children: parsedChildren);
        }
        return item;
      }

      final List<ProtocolHierarchy> allItems = [];
      for (var itemJson in itemsList) {
        final item = ProtocolHierarchy.fromJson(itemJson);
        allItems.add(item);
      }

      final trees = TreeBuilder.buildTree(allItems);

      ProtocolHierarchy? result;
      for (var tree in trees) {
        if (tree.id == hierarchyId) {
          result = tree;
          break;
        }
      }

      if (result == null) {
        for (var tree in trees) {
          result = _findItemInTree(tree, hierarchyId);
          if (result != null) {
            break;
          }
        }
      }

      if (result == null) {
        throw Exception('Не удалось найти элемент с id=$hierarchyId');
      }

      return result;

    } catch (e) {
      rethrow;
    }
  }

  ProtocolHierarchy? _findItemInTree(ProtocolHierarchy item, int targetId) {
    if (item.id == targetId) {
      return item;
    }
    for (var child in item.children) {
      final found = _findItemInTree(child, targetId);
      if (found != null) {
        return found;
      }
    }
    return null;
  }

  List<ProtocolHierarchy> _parseChildrenFromJson(List<dynamic> childrenJson) {
    final List<ProtocolHierarchy> children = [];

    for (var childJson in childrenJson) {
      final child = ProtocolHierarchy.fromJson(childJson);
      if (childJson['children'] != null && childJson['children'] is List) {
        children.add(child.copyWith(
          children: _parseChildrenFromJson(childJson['children']),
        ));
      } else {
        children.add(child);
      }
    }

    return children;
  }
}