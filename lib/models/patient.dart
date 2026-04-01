class Patient {
  final int patientId;
  final int motherId;
  final String dateOfBirth;
  final String gender;
  final String numberHistory;
  final String? motherName;
  final String? bloodGroup;
  final String? rhFactor;
  final int? weight;
  final int? height;

  Patient({
    required this.patientId,
    required this.motherId,
    required this.dateOfBirth,
    required this.gender,
    required this.numberHistory,
    this.motherName,
    this.bloodGroup,
    this.rhFactor,
    this.weight,
    this.height,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      patientId: json['patient_id'],
      motherId: json['mother_id'],
      dateOfBirth: json['date_of_birth'],
      gender: json['gender'],
      numberHistory: json['number_history'] ?? 'Не указан',
      motherName: json['mother_name']?.trim(),
      bloodGroup: json['blood_group'],
      rhFactor: json['rh_factor'],
      weight: json['weight']?.toInt(),
      height: json['height']?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'mother_id': motherId,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'number_history': numberHistory,
      'mother_name': motherName,
      'blood_group': bloodGroup,
      'rh_factor': rhFactor,
      'weight': weight,
      'height': height,
    };
  }

  String get formattedBloodType {
    if (bloodGroup == null || rhFactor == null) {
      return 'Не указано';
    }
    return '$bloodGroup, ${rhFactor == '+' ? 'Rh+' : 'Rh−'}';
  }

  String get formattedWeight {
    if (weight == null) return 'Не указан';
    return '${weight!.toStringAsFixed(0)} грамм';
  }

  String get formattedHeight {
    if (height == null) return 'Не указан';
    return '${height!.toStringAsFixed(0)} сантиметров';
  }

  int getId() {
    return patientId;
  }
}