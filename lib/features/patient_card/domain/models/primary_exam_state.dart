import '../entities/medical_parameter_value.dart';

class PrimaryExamState {
  List<MedicalParameterValue> _parameters = [];
  bool _isLoading = true;
  String? _error;

  List<MedicalParameterValue> get parameters => _parameters;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasData => _parameters.isNotEmpty;
  bool get isEmpty => _parameters.isEmpty;

  void setParameters(List<MedicalParameterValue> parameters) {
    _parameters = parameters;
  }

  void setLoading(bool loading) {
    _isLoading = loading;
  }

  void setError(String? error) {
    _error = error;
  }

  void reset() {
    _parameters = [];
    _isLoading = true;
    _error = null;
  }
}