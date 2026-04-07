class MedicalParameter {
  final int id;
  final String name;
  final String valueType;
  final String? unit;
  final String? description;
  final List<String>? options;

  const MedicalParameter({
    required this.id,
    required this.name,
    required this.valueType,
    this.unit,
    this.description,
    this.options,
  });

  factory MedicalParameter.fromJson(Map<String, dynamic> json) {
    return MedicalParameter(
      id: json['medical_parameter_id'],
      name: json['name'],
      valueType: json['value_type'],
      unit: json['unit'],
      description: json['description'],
      options: json['options'] != null
          ? List<String>.from(json['options'])
          : null,
    );
  }
}