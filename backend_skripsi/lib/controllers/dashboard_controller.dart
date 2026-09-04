import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../db_connection.dart';

class DashboardController {
  Future<Response> getStatistik(Request request) async {
    final conn = await DbConnection.getConnection();
    
    try {
      // Menghitung Total KK
      var resKk = await conn.query('SELECT COUNT(*) as total FROM keluarga');
      var totalKk = resKk.first['total'];

      // Menghitung Total Warga (Anggota Keluarga)
      var resWarga = await conn.query('SELECT COUNT(*) as total FROM anggota_keluarga');
      var totalWarga = resWarga.first['total'];

      // Menghitung Total Balita (<= 5 Tahun)
      var resBalita = await conn.query('''
        SELECT COUNT(*) as total FROM anggota_keluarga 
        WHERE TIMESTAMPDIFF(YEAR, tanggal_lahir, CURDATE()) <= 5
      ''');
      var totalBalita = resBalita.first['total'];

      // Menghitung Total Lansia (>= 60 Tahun)
      var resLansia = await conn.query('''
        SELECT COUNT(*) as total FROM anggota_keluarga 
        WHERE TIMESTAMPDIFF(YEAR, tanggal_lahir, CURDATE()) >= 60
      ''');
      var totalLansia = resLansia.first['total'];

      var data = {
        'status': 'success',
        'data': {
          'total_kk': totalKk,
          'total_warga': totalWarga,
          'total_balita': totalBalita,
          'total_lansia': totalLansia,
        }
      };

      return Response.ok(jsonEncode(data), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    } finally {
      await conn.close();
    }
  }
}