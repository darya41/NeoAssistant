import '../../../../core/network/api_client.dart';
import '../../domain/entities/address.dart';

class AddressService {

  Future<Map<String, dynamic>> createAddress(Address address) async {
    final response = await ApiClient.postAuth('addresses', address.toJson());

    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }

    return response;
  }
}