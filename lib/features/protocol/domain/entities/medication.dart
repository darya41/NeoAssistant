class Medication {
  final int id;
  final String inn;
  final String? brandName;
  final String? dosageForm;
  final String? strength;
  final String? drugClass;
  final String? specialNotes;

  Medication({
    required this.id,
    required this.inn,
    this.brandName,
    this.dosageForm,
    this.strength,
    this.drugClass,
    this.specialNotes,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'] ?? 0,
      inn: json['inn'] ?? '',
      brandName: json['brand_name'],
      dosageForm: json['dosage_form'],
      strength: json['strength'],
      drugClass: json['drug_class'],
      specialNotes: json['special_notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inn': inn,
      'brand_name': brandName,
      'dosage_form': dosageForm,
      'strength': strength,
      'drug_class': drugClass,
      'special_notes': specialNotes,
    };
  }
}