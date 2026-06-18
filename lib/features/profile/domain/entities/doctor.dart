class Doctor {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String? patronymic;
  final int? techLevelId;
  final String? specialization;
  final String? workPhone;
  final String? personalPhone;

  String get fullName => [lastName, firstName, patronymic]
      .where((name) => name != null && name.isNotEmpty)
      .join(' ');

  String get displayPhone => workPhone ?? personalPhone ?? '';

  const Doctor({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.patronymic,
    this.techLevelId,
    this.specialization,
    this.workPhone,
    this.personalPhone,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {

    return Doctor(
      id: json['id'] ?? json['doctor_id'] ?? 0,
      email: json['email'] ?? json['work_email'] ?? '',
      firstName: json['firstName'] ?? json['first_name'] ?? '',
      lastName: json['lastName'] ?? json['last_name'] ?? '',
      patronymic: json['patronymic'] ?? json['middle_name'],
      techLevelId: json['tech_level_id'],
      specialization: json['specialization'],
      workPhone: json['workPhone'] ?? json['work_phone'] ?? json['phone'],
      personalPhone: json['personalPhone'] ?? json['personal_phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'patronymic': patronymic,
      'tech_level_id': techLevelId,
      'specialization': specialization,
      'workPhone': workPhone,
      'personalPhone': personalPhone,
    };
  }
}