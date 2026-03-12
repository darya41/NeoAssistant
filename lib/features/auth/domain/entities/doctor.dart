class Doctor {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String? patronymic;
  final String? specialization;
  final String? workPhone;
  final String? personalPhone;

  String get fullName => [lastName, firstName, patronymic]
      .where((name) => name != null && name.isNotEmpty)
      .join(' ');

  const Doctor({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.patronymic,
    this.specialization,
    this.workPhone,
    this.personalPhone,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['doctor_id'] ?? json['id'] ?? 0,
      email: json['work_email'] ?? json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      patronymic: json['patronymic'],
      specialization: json['specialization_name'] ?? json['specialization'],
      workPhone: json['work_phone'],
      personalPhone: json['personal_phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctor_id': id,
      'work_email': email,
      'first_name': firstName,
      'last_name': lastName,
      'patronymic': patronymic,
      'work_phone': workPhone,
      'personal_phone': personalPhone,
    };
  }
}