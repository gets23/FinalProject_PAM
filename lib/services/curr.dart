import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  // Kita pakai API gratis, basisnya USD
  final String _apiUrl = "https://api.exchangerate-api.com/v4/latest/USD";

  Future<Map<String, dynamic>> getExchangeRates() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Kita hanya butuh bagian 'rates'-nya
        return data['rates'] as Map<String, dynamic>;
      } else {
        throw Exception('Gagal memuat kurs mata uang');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}