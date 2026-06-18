import '../../domain/entities/address.dart';
import '../services/address_service.dart';

class AddressRepository {
  final AddressService _addressService = AddressService();

  Future<Address> createAddress(Address address) async {
    try {
      final response = await _addressService.createAddress(address);

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка создания адреса');
      }

      final addressData = response['data'];

      if (addressData == null) {
        return Address(
          id: null,
          settlementType: address.settlementType,
          city: address.city,
          addressType: address.addressType,
          street: address.street,
          houseNumber: address.houseNumber,
          apartment: address.apartment,
          building: address.building,
        );
      }

      final addressJson = _extractAddressData(addressData);
      return Address.fromJson(addressJson);
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> _extractAddressData(dynamic addressData) {
    if (addressData is List) {
      if (addressData.isEmpty) {
        throw Exception('Сервер вернул пустой список адресов');
      }
      if (addressData[0] is! Map<String, dynamic>) {
        throw Exception('Неверный формат адреса в списке');
      }
      return addressData[0];
    } else if (addressData is Map<String, dynamic>) {
      return addressData;
    } else {
      throw Exception('Неверный тип data: ${addressData.runtimeType}');
    }
  }
}