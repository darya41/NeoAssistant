class Address {
  final int id;
  final String? settlementType;
  final String? city;
  final String? addressType;
  final String? street;
  final String? houseNumber;
  final String? apartment;
  final String? building;

  const Address({
    required this.id,
    this.settlementType,
    this.city,
    this.addressType,
    this.street,
    this.houseNumber,
    this.apartment,
    this.building,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['address_id'] ?? 0,
      settlementType: json['settlement_type'],
      city: json['city'],
      addressType: json['address_type'],
      street: json['street'],
      houseNumber: json['house_number'],
      apartment: json['apartment'],
      building: json['building'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'settlement_type': settlementType,
      'city': city,
      'address_type': addressType,
      'street': street,
      'house_number': houseNumber,
      'apartment': apartment,
      'building': building,
    };
  }

  String get fullAddress {
    final parts = <String>[];

    if (settlementType != null && city != null) {
      parts.add('$settlementType $city');
    } else if (city != null) {
      parts.add(city!);
    }

    if (street != null && street!.isNotEmpty) {
      final streetPart = addressType != null ? '$addressType $street' : 'ул. $street';
      parts.add(streetPart);
    }

    if (houseNumber != null && houseNumber!.isNotEmpty) {
      parts.add('д. $houseNumber');
    }

    if (building != null && building!.isNotEmpty) {
      parts.add('корп. $building');
    }

    if (apartment != null && apartment!.isNotEmpty) {
      parts.add('кв. $apartment');
    }

    return parts.isNotEmpty ? parts.join(', ') : 'Адрес не указан';
  }
}