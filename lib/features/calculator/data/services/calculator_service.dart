import 'package:http/http.dart' as http;
import '../../../../core/storage/token_storage.dart';

class CalculatorService {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  Future<http.Response> getCalculators() async {
    final token = await TokenStorage.getAccessToken();

    return await http.get(
      Uri.parse('$baseUrl/calculators'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> getCalculatorById(int id) async {
    final token = await TokenStorage.getAccessToken();

    return await http.get(
      Uri.parse('$baseUrl/calculators/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> searchCalculators(String query) async {
    final token = await TokenStorage.getAccessToken();

    return await http.get(
      Uri.parse('$baseUrl/calculators/search?q=$query'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }
}