import '../../../../core/network/api_client.dart';
import '../../../../models/address.dart';

class AddressRepository {
  Future<Address> createAddress(Address address) async {
    try {
      final response = await ApiClient.postAuth('addresses', address.toJson());

      if (response is! Map<String, dynamic>) {
        throw Exception('Неверный формат ответа. Ожидался Map, получен ${response.runtimeType}');
      }

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

      Map<String, dynamic> addressJson;

      if (addressData is List) {
        if (addressData.isEmpty) {
          throw Exception('Сервер вернул пустой список адресов');
        }
        if (addressData[0] is! Map<String, dynamic>) {
          throw Exception('Неверный формат адреса в списке');
        }
        addressJson = addressData[0];
      } else if (addressData is Map<String, dynamic>) {
        addressJson = addressData;
      } else {
        throw Exception('Неверный тип data: ${addressData.runtimeType}');
      }

      return Address.fromJson(addressJson);

    } catch (e) {
      rethrow;
    }
  }
}