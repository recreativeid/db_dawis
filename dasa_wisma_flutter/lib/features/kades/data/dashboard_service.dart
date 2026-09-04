import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/network/api_config.dart';

class DashboardService {
  Future<Map<String, dynamic>> fetchStatistik() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.statistikUrl));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Gagal mengambil data statistik');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
