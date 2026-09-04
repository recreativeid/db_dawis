import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../db_connection.dart';
import 'package:shelf_router/shelf_router.dart';

class KeluargaController {
  
  // GET: Tampil & Cari Data
  Future<Response> index(Request request) async {
    final conn = await DbConnection.getConnection();
    // Menangkap query parameter ?cari=
    final keyword = request.url.queryParameters['cari'] ?? '';

    try {
      // Query dengan JOIN sederhana
      var results = await conn.query('''
        SELECT k.id as keluarga_id, k.no_kk, k.kriteria_rumah, a.id as anggota_id, a.nik, a.nama_lengkap, a.status_keluarga 
        FROM keluarga k
        JOIN anggota_keluarga a ON k.id = a.keluarga_id
        WHERE k.no_kk LIKE ? OR a.nama_lengkap LIKE ?
      ''', ['%$keyword%', '%$keyword%']);

      List<Map<String, dynamic>> listData = [];
      for (var row in results) {
        listData.add(row.fields);
      }

      return Response.ok(jsonEncode({'status': 'success', 'data': listData}), 
          headers: {'Content-Type': 'application/json'});
    } finally {
      await conn.close();
    }
  }

  // POST: Tambah Data Keluarga Sekaligus Kepala Keluarga
  Future<Response> store(Request request) async {
    final payload = await request.readAsString();
    final data = jsonDecode(payload);
    final conn = await DbConnection.getConnection();

    try {
      // Kita gunakan Transaction agar jika gagal satu, semua di-rollback
      await conn.transaction((ctx) async {
        // 1. Insert ke tabel keluarga
        var resKeluarga = await ctx.query('''
          INSERT INTO keluarga (no_kk, dawis_id, kriteria_rumah) 
          VALUES (?, ?, ?)
        ''', [data['no_kk'], data['dawis_id'], data['kriteria_rumah']]);
        
        var keluargaId = resKeluarga.insertId; // Ambil ID keluarga yang baru dibuat

        // 2. Insert ke tabel anggota_keluarga sebagai Kepala Keluarga
        await ctx.query('''
          INSERT INTO anggota_keluarga (keluarga_id, nik, nama_lengkap, jenis_kelamin, tanggal_lahir, status_keluarga) 
          VALUES (?, ?, ?, ?, ?, 'Kepala Keluarga')
        ''', [keluargaId, data['nik'], data['nama_lengkap'], data['jenis_kelamin'], data['tanggal_lahir']]);
      });

      return Response.ok(jsonEncode({'message': 'Data KK dan Kepala Keluarga berhasil disimpan!'}), 
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'message': 'Gagal menyimpan', 'error': e.toString()}));
    } finally {
      await conn.close();
    }
  }

  // PUT: Update Data Anggota Keluarga
  Future<Response> update(Request request) async {
    final id = request.params['id'];
    if (id == null) return Response.badRequest(body: 'ID is missing');

    final payload = await request.readAsString();
    final data = jsonDecode(payload);
    final conn = await DbConnection.getConnection();

    try {
      if (data.containsKey('nama_lengkap') || data.containsKey('nik')) {
        var currentRes = await conn.query('SELECT nama_lengkap, nik FROM anggota_keluarga WHERE id = ?', [id]);
        if (currentRes.isNotEmpty) {
          var current = currentRes.first;
          var namaLengkap = data['nama_lengkap'] ?? current['nama_lengkap'];
          var nik = data['nik'] ?? current['nik'];
          
          await conn.query('''
            UPDATE anggota_keluarga 
            SET nama_lengkap = ?, nik = ?
            WHERE id = ?
          ''', [namaLengkap, nik, id]);
        }
      }

      // Jika kriteria_rumah juga diupdate (khusus Kepala Keluarga misalnya)
      if (data.containsKey('kriteria_rumah') && data.containsKey('keluarga_id')) {
         await conn.query('''
          UPDATE keluarga 
          SET kriteria_rumah = ?
          WHERE id = ?
        ''', [data['kriteria_rumah'], data['keluarga_id']]);
      }

      // Jika validasi & persetujuan bantuan dari Kades
      if (data.containsKey('is_bantuan_disetujui')) {
        var res = await conn.query('SELECT keluarga_id FROM anggota_keluarga WHERE id = ?', [id]);
        if (res.isNotEmpty) {
          var keluargaId = res.first['keluarga_id'];
          var resBantuan = await conn.query('SELECT id FROM master_bantuan LIMIT 1');
          int bantuanId;
          if (resBantuan.isEmpty) {
            var insBantuan = await conn.query("INSERT INTO master_bantuan (nama_bantuan, keterangan) VALUES ('BLT Dana Desa', 'Bantuan Langsung Tunai')");
            bantuanId = insBantuan.insertId!;
          } else {
            bantuanId = resBantuan.first['id'];
          }
          await conn.query('UPDATE keluarga SET bantuan_id = ? WHERE id = ?', [bantuanId, keluargaId]);
        }
      }

      return Response.ok(jsonEncode({'message': 'Data berhasil diupdate!'}), 
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'message': 'Gagal mengupdate', 'error': e.toString()}));
    } finally {
      await conn.close();
    }
  }

  // DELETE: Hapus Data Keluarga (beserta anggotanya berkat CASCADE)
  Future<Response> destroy(Request request) async {
    final id = request.params['id']; // ID keluarga
    if (id == null) return Response.badRequest(body: 'ID is missing');

    final conn = await DbConnection.getConnection();

    try {
      await conn.query('DELETE FROM keluarga WHERE id = ?', [id]);
      return Response.ok(jsonEncode({'message': 'Data keluarga berhasil dihapus!'}), 
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'message': 'Gagal menghapus', 'error': e.toString()}));
    } finally {
      await conn.close();
    }
  }
}