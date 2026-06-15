import 'package:flutter/material.dart';
import '../../data/repositories/protocol_repository.dart';
import '../../domain/entities/protocol_document.dart';
import '../../domain/entities/protocol_hierarchy.dart';

class ProtocolDetailViewModel extends ChangeNotifier {
  final ProtocolRepository _repository = ProtocolRepository();
  final int protocolDocumentId;
  final int? selectedHierarchyId;

  ProtocolDocument? _document;
  List<ProtocolHierarchy> _fullHierarchy = [];
  List<ProtocolHierarchy> _chapters = [];
  List<ProtocolHierarchy> _displayContentItems = [];
  bool _isLoading = false;
  String? _error;
  bool _isPreambleExpanded = false;
  int? _selectedItemId;
  int? _isLoadingItem;

  final Set<int> _expandedChapters = {};

  ProtocolDocument? get document => _document;
  List<ProtocolHierarchy> get chapters => _chapters;
  List<ProtocolHierarchy> get displayContentItems => _displayContentItems;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isPreambleExpanded => _isPreambleExpanded;
  int? get selectedItemId => _selectedItemId;
  int? get isLoadingItem => _isLoadingItem;
  Set<int> get expandedChapters => _expandedChapters;

  ProtocolDetailViewModel({
    required this.protocolDocumentId,
    this.selectedHierarchyId,
  }) {
    loadProtocol();
  }

  Future<void> loadProtocol() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {

      _document = await _repository.getProtocolDocumentById(protocolDocumentId);

      _fullHierarchy = await _repository.getProtocolHierarchy(protocolDocumentId);

      _chapters = _getAllChapters(_fullHierarchy);

      if (selectedHierarchyId != null) {
        await selectItem(selectedHierarchyId!);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  List<ProtocolHierarchy> _getAllChapters(List<ProtocolHierarchy> items) {
    final List<ProtocolHierarchy> chapters = [];
    for (final item in items) {
      if (item.level == 1) {
        chapters.add(item);
      }
      if (item.children.isNotEmpty) {
        chapters.addAll(_getAllChapters(item.children));
      }
    }
    return chapters;
  }

  Future<void> selectItem(int itemId) async {

    if (_selectedItemId == itemId) {
      toggleChapterExpanded(itemId);
      return;
    }

    _isLoadingItem = itemId;
    _selectedItemId = itemId;
    notifyListeners();

    try {
      final fullBranchItem = await _repository.getFullBranch(itemId);

      void printChildren(ProtocolHierarchy node, int depth) {
        for (var child in node.children) {
          if (child.children.isNotEmpty) {
            printChildren(child, depth + 1);
          }
        }
      }
      printChildren(fullBranchItem, 1);

      _displayContentItems = _getAllItemsWithContent(fullBranchItem);

      _expandedChapters.add(itemId);

      _isLoadingItem = null;
      notifyListeners();
    } catch (e) {
      _isLoadingItem = null;
      _error = e.toString();
      notifyListeners();
    }
  }

  List<ProtocolHierarchy> _getAllItemsWithContent(ProtocolHierarchy rootItem) {
    final List<ProtocolHierarchy> result = [];

    result.add(rootItem);

    void addChildren(ProtocolHierarchy parent) {
      for (final child in parent.children) {
        result.add(child);
        if (child.children.isNotEmpty) {
          addChildren(child);
        }
      }
    }

    addChildren(rootItem);
    return result;
  }

  void togglePreamble() {
    _isPreambleExpanded = !_isPreambleExpanded;
    notifyListeners();
  }

  void toggleChapterExpanded(int chapterId) {
    if (_expandedChapters.contains(chapterId)) {
      _expandedChapters.remove(chapterId);
      if (_selectedItemId == chapterId) {
        _displayContentItems = [];
      }
    } else {
      _expandedChapters.add(chapterId);
      if (_selectedItemId == chapterId && _displayContentItems.isEmpty) {
        selectItem(chapterId);
        return;
      }
    }
    notifyListeners();
  }

  Future<void> refresh() async {
    _displayContentItems = [];
    _selectedItemId = null;
    _expandedChapters.clear();
    await loadProtocol();
  }
}