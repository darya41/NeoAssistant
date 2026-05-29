import '../../domain/entities/protocol_document.dart';
import '../../domain/entities/protocol_hierarchy.dart';
import '../../domain/entities/protocol_list_item.dart';
import '../../domain/utils/title_cleaner.dart';
import '../../domain/utils/tree_builder.dart';
import '../services/protocol_service.dart';

class ProtocolRepository {
  final ProtocolService _service = ProtocolService();

  Future<Map<String, dynamic>> getProtocolListPaginated({int page = 1, int limit = 20, }) async {
    try {
      final response = await _service.getProtocolFlatListPaginated(
        page: page,
        limit: limit,
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка получения списка протоколов');
      }

      final data = response['data'];
      final pagination = response['pagination'] ?? {};

      final List<ProtocolListItem> items = (data as List)
          .map((json) {
        final item = ProtocolListItem.fromJson(json);
        final cleanedTitle = TitleCleaner.clean(item.hierarchyTitle);
        return ProtocolListItem(
          protocolDocumentId: item.protocolDocumentId,
          protocolTitle: item.protocolTitle,
          hierarchyId: item.hierarchyId,
          hierarchyTitle: cleanedTitle,
          level: item.level,
          parentId: item.parentId,
          content: item.content,
        );
      })
          .toList();

      return {
        'items': items,
        'hasNext': pagination['hasNext'] ?? false,
        'currentPage': pagination['currentPage'] ?? page,
        'total': pagination['total'] ?? 0,
      };
    } catch (e) {
      rethrow;
    }
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


  Future<Map<String, dynamic>> searchProtocolsPaginated({
    required String query, int page = 1, int limit = 20,
  }) async {
    try {
      final response = await _service.searchProtocols(
        query: query, page: page, limit: limit,
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка поиска протоколов');
      }

      final data = response['data'];
      final pagination = response['pagination'] ?? {};

      final List<ProtocolListItem> items = (data as List)
          .map((json) {
        final item = ProtocolListItem.fromJson(json);
        final cleanedTitle = TitleCleaner.clean(item.hierarchyTitle);
        return ProtocolListItem(
          protocolDocumentId: item.protocolDocumentId,
          protocolTitle: item.protocolTitle,
          hierarchyId: item.hierarchyId,
          hierarchyTitle: cleanedTitle,
          level: item.level,
          parentId: item.parentId,
          content: item.content,
        );
      })
          .toList();

      return {
        'items': items,
        'hasNext': pagination['hasNext'] ?? false,
        'currentPage': pagination['currentPage'] ?? page,
        'total': pagination['total'] ?? 0,
      };
    } catch (e) {
      rethrow;
    }
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

  Future<Map<String, dynamic>> getProtocolsByMedicationPaginated({
    required int medicationId, int page = 1, int limit = 20,
  }) async {
    try {
      final response = await _service.getProtocolsByMedication(
        medicationId: medicationId, page: page, limit: limit,
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка получения протоколов по препарату');
      }

      final data = response['data'];
      final pagination = response['pagination'] ?? {};

      final List<ProtocolListItem> items = (data as List)
          .map((json) => ProtocolListItem.fromJson(json))
          .toList();

      return {
        'items': items,
        'hasNext': pagination['hasNext'] ?? false,
        'currentPage': pagination['currentPage'] ?? page,
        'total': pagination['total'] ?? 0,
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getProtocolsByDiagnosticPaginated({
    required int diagnosticId, int page = 1, int limit = 20,
  }) async {
    try {
      final response = await _service.getProtocolsByDiagnostic(
        diagnosticId: diagnosticId, page: page, limit: limit,
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка получения протоколов по диагностике');
      }

      final data = response['data'];
      final pagination = response['pagination'] ?? {};

      final List<ProtocolListItem> items = (data as List)
          .map((json) => ProtocolListItem.fromJson(json))
          .toList();

      return {
        'items': items,
        'hasNext': pagination['hasNext'] ?? false,
        'currentPage': pagination['currentPage'] ?? page,
        'total': pagination['total'] ?? 0,
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getProtocolsByMkbPaginated({
    required int mkbId, int page = 1, int limit = 20,
  }) async {
    try {
      final response = await _service.getProtocolsByMkb(
        mkbId: mkbId, page: page, limit: limit,
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка получения протоколов по МКБ');
      }

      final data = response['data'];
      final pagination = response['pagination'] ?? {};

      final List<ProtocolListItem> items = (data as List)
          .map((json) => ProtocolListItem.fromJson(json))
          .toList();

      return {
        'items': items,
        'hasNext': pagination['hasNext'] ?? false,
        'currentPage': pagination['currentPage'] ?? page,
        'total': pagination['total'] ?? 0,
      };
    } catch (e) {
      rethrow;
    }
  }

}