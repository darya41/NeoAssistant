class Patient {
  final int patientId;
  final int motherId;
  final String dateOfBirth;
  final String gender;
  final String numberHistory;
  final String motherName;

  Patient({
    required this.patientId,
    required this.motherId,
    required this.dateOfBirth,
    required this.gender,
    required this.numberHistory,
    required this.motherName,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      patientId: json['patient_id'],
      motherId: json['mother_id'],
      dateOfBirth: json['date_of_birth'],
      gender: json['gender'],
      numberHistory: json['number_history'] ?? 'Не указан',
      motherName: json['mother_name']?.trim() ?? 'Мать не указана',
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
    };
  }
}