import '../entities/protocol_hierarchy.dart';

class TreeBuilder {
  static List<ProtocolHierarchy> buildTree(List<ProtocolHierarchy> items) {
    final Map<int, ProtocolHierarchy> itemMap = {};
    final Map<int, List<ProtocolHierarchy>> childrenMap = {};

    for (final item in items) {
      itemMap[item.id] = item;
      if (item.parentId != null) {
        childrenMap.putIfAbsent(item.parentId!, () => []);
        childrenMap[item.parentId!]!.add(item);
      }
    }

    List<ProtocolHierarchy> buildChildren(ProtocolHierarchy parent) {
      final children = childrenMap[parent.id] ?? [];
      final updatedChildren = <ProtocolHierarchy>[];
      for (final child in children) {
        updatedChildren.add(child.copyWith(children: buildChildren(child)));
      }
      return updatedChildren;
    }

    final roots = <ProtocolHierarchy>[];
    for (final item in items) {
      if (item.parentId == null) {
        roots.add(item.copyWith(children: buildChildren(item)));
      }
    }

    return roots;
  }

  static bool hasGrandchildren(ProtocolHierarchy item) {
    for (final child in item.children) {
      if (child.children.isNotEmpty) {
        return true;
      }
      if (hasGrandchildren(child)) {
        return true;
      }
    }
    return false;
  }
}