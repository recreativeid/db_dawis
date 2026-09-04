import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/network/api_config.dart';

class WargaService {
  Future<List<dynamic>> fetchKeluarga({String query = ''}) async {
    try {
      final url = query.isEmpty 
          ? ApiConfig.keluargaUrl 
          : '${ApiConfig.keluargaUrl}?cari=$query';
          
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Gagal mengambil data keluarga');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> tambahKeluarga(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.keluargaUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> updateKeluarga(String anggotaId, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.keluargaUrl}/$anggotaId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> hapusKeluarga(String keluargaId) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.keluargaUrl}/$keluargaId'),
      );
      
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
