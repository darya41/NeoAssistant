import 'package:flutter/material.dart';

import '../../data/repositories/protocol_repository.dart';
import '../../domain/entities/detail_protocol.dart';

class ProtocolDetailViewModel extends ChangeNotifier {
  final ProtocolRepository _repository = ProtocolRepository();

  DetailProtocol? _detail;
  bool _isLoading = true;
  String? _error;
  int? _protocolId;

  DetailProtocol? get detail => _detail;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadDetail(int protocolId) async {
    _protocolId = protocolId;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _detail = await _repository.getByProtocolId(protocolId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> retry() async {
    if (_protocolId != null) {
      await loadDetail(_protocolId!);
    }
  }
}