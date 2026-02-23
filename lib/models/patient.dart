class Patient {
  final String cardNumber;
  final String status;
  final String patientName;
  final String birthDate;
  final String gender;
  final String bloodType;
  final bool hasConcern;

  const Patient({
    required this.cardNumber,
    required this.status,
    required this.patientName,
    required this.birthDate,
    required this.gender,
    required this.bloodType,
    required this.hasConcern,
  });

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      cardNumber: map['cardNumber'],
      status: map['status'],
      patientName: map['patientName'],
      birthDate: map['birthDate'],
      gender: map['gender'],
      bloodType: map['bloodType'],
      hasConcern: map['hasConcern'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cardNumber': cardNumber,
      'status': status,
      'patientName': patientName,
      'birthDate': birthDate,
      'gender': gender,
      'bloodType': bloodType,
      'hasConcern': hasConcern,
    };
  }
}