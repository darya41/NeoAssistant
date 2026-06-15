import '../entities/mother.dart';
import '../entities/patient.dart';

class PatientDetailsState {
  final Patient patient;
  final Mother? mother;
  final bool isLoadingMother;
  final String? motherError;

  const PatientDetailsState({
    required this.patient,
    this.mother,
    this.isLoadingMother = false,
    this.motherError,
  });

  PatientDetailsState copyWith({
    Patient? patient,
    Mother? mother,
    bool? isLoadingMother,
    String? motherError,
  }) {
    return PatientDetailsState(
      patient: patient ?? this.patient,
      mother: mother ?? this.mother,
      isLoadingMother: isLoadingMother ?? this.isLoadingMother,
      motherError: motherError ?? this.motherError,
    );
  }

  String get formattedMotherBloodGroup {
    if (motherError != null) return 'Ошибка: $motherError';
    if (isLoadingMother) return 'Загрузка...';
    if (mother == null) return 'Не указано';

    return BloodTypeFormatter.format(
      mother!.bloodGroup,
      mother!.rhFactor,
    );
  }

  String get formattedChildBloodGroup {
    if (motherError != null) return 'Ошибка: $motherError';
    if (isLoadingMother) return 'Загрузка...';
    if (mother == null) return 'Не указано';

    return BloodTypeFormatter.format(
      patient.bloodGroup,
      patient.rhFactor,
    );
  }

  String get formattedBirthDate {
    final date = DateTime.tryParse(patient.dateOfBirth);
    if (date == null) return patient.dateOfBirth;
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String get formattedBirthTime {
    final date = DateTime.tryParse(patient.dateOfBirth);
    if (date == null) return '--:--';
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String get formattedGender {
    return patient.gender == 'MALE' ? 'Мужской' : 'Женский';
  }
}

class BloodTypeFormatter {
  static String format(String? bloodGroup, String? rhFactor) {
    if (bloodGroup == null || bloodGroup.isEmpty) {
      return 'Не указано';
    }

    if (rhFactor == null || rhFactor.isEmpty) {
      return '$bloodGroup (${_getRomanNumeral(bloodGroup)}), Rh не указан';
    }

    final romanNumeral = _getRomanNumeral(bloodGroup);
    return '$bloodGroup ($romanNumeral), Rh$rhFactor';
  }

  static String _getRomanNumeral(String bloodGroup) {
    switch (bloodGroup.toUpperCase()) {
      case 'A':
        return 'II';
      case 'B':
        return 'III';
      case 'AB':
        return 'IV';
      case 'O':
        return 'I';
      default:
        return bloodGroup;
    }
  }
}