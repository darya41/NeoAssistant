class Mother {
  final int id;
  final String firstName;
  final String lastName;
  final String? patronymic;
  final DateTime dateOfBirth;
  final int? numberOfDeliveries;
  final int? numberOfPregnancies;
  final String? medicalHistory;
  final String? medicationsDuringPregnancy;
  final bool? gestationalDiabetes;
  final bool? preeclampsia;
  final String? groupBStreptococcusStatus;
  final int? addressId;
  final String? bloodGroup;
  final String? rhFactor;

  String get fullName => [lastName, firstName, patronymic]
      .where((name) => name != null && name.isNotEmpty)
      .join(' ');

  const Mother({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.patronymic,
    required this.dateOfBirth,
    this.numberOfDeliveries,
    this.numberOfPregnancies,
    this.medicalHistory,
    this.medicationsDuringPregnancy,
    this.gestationalDiabetes,
    this.preeclampsia,
    this.groupBStreptococcusStatus,
    this.addressId,
    this.bloodGroup,
    this.rhFactor,
  });

  factory Mother.fromJson(Map<String, dynamic> json) {
    return Mother(
      id: json['mother_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      patronymic: json['patronymic'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      numberOfDeliveries: json['number_of_deliveries'],
      numberOfPregnancies: json['number_of_pregnancies'],
      medicalHistory: json['medical_history'],
      medicationsDuringPregnancy: json['medications_during_pregnancy'],
      gestationalDiabetes: json['gestational_diabetes'] == 1,
      preeclampsia: json['preeclampsia'] == 1,
      groupBStreptococcusStatus: json['groupb_streptococcus_status'],
      addressId: json['address_id'],
      bloodGroup: json['blood_group'],
      rhFactor: json['rh_factor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'patronymic': patronymic,
      'date_of_birth': dateOfBirth.toIso8601String().split('T')[0],
      'number_of_deliveries': numberOfDeliveries,
      'number_of_pregnancies': numberOfPregnancies,
      'medical_history': medicalHistory,
      'medications_during_pregnancy': medicationsDuringPregnancy,
      'gestational_diabetes': gestationalDiabetes == true ? 1 : 0,
      'preeclampsia': preeclampsia == true ? 1 : 0,
      'groupb_streptococcus_status': groupBStreptococcusStatus,
      'address_id': addressId,
      'blood_group': bloodGroup,
      'rh_factor': rhFactor,
    };
  }

  Mother copyWith({
    int? id,
    String? lastName,
    String? firstName,
    String? patronymic,
    DateTime? dateOfBirth,
    int? numberOfPregnancies,
    int? numberOfDeliveries,
    String? medicalHistory,
    String? medicationsDuringPregnancy,
    bool? gestationalDiabetes,
    bool? preeclampsia,
    String? groupBStreptococcusStatus,
    int? addressId,
    String? bloodGroup,
    String? rhFactor,
  }) {
    return Mother(
      id: id ?? this.id,
      lastName: lastName ?? this.lastName,
      firstName: firstName ?? this.firstName,
      patronymic: patronymic ?? this.patronymic,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      numberOfPregnancies: numberOfPregnancies ?? this.numberOfPregnancies,
      numberOfDeliveries: numberOfDeliveries ?? this.numberOfDeliveries,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      medicationsDuringPregnancy: medicationsDuringPregnancy ?? this.medicationsDuringPregnancy,
      gestationalDiabetes: gestationalDiabetes ?? this.gestationalDiabetes,
      preeclampsia: preeclampsia ?? this.preeclampsia,
      groupBStreptococcusStatus: groupBStreptococcusStatus ?? this.groupBStreptococcusStatus,
      addressId: addressId ?? this.addressId,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      rhFactor: rhFactor ?? this.rhFactor,
    );
  }
}