import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

import '../lib/controllers/dashboard_controller.dart';
import '../lib/controllers/keluarga_controller.dart';

void main() async {
  // Inisialisasi Controller
  final dashboardCtrl = DashboardController();
  final keluargaCtrl = KeluargaController();

  // Konfigurasi Router (Daftar URL API)
  final router = Router()
    ..get('/api/dashboard/statistik', dashboardCtrl.getStatistik)
    ..get('/api/keluarga', keluargaCtrl.index)
    ..post('/api/keluarga', keluargaCtrl.store)
    ..put('/api/keluarga/<id>', keluargaCtrl.update)
    ..delete('/api/keluarga/<id>', keluargaCtrl.destroy);

  // Middleware untuk log request (opsional tapi disarankan)
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router);

  // Menjalankan Server di port 8080
  final server = await io.serve(handler, InternetAddress.anyIPv4, 8080);
  print('✅ Server Backend API berjalan di http://${server.address.host}:${server.port}');
}