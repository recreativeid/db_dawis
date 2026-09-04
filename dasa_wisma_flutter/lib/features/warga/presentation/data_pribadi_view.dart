import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/app_provider.dart';

class DataPribadiView extends StatelessWidget {
  const DataPribadiView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final currentUser = provider.currentUser;
    
    // Find KK matching current logged in Warga user
    final keluarga = provider.keluargaList.cast<dynamic>().firstWhere(
      (k) => currentUser != null && (
        k.namaKepalaKeluarga.toLowerCase() == currentUser.namaLengkap.toLowerCase() ||
        k.nikHead == currentUser.username ||
        k.nikHead == currentUser.nik
      ),
      orElse: () => provider.keluargaList.cast<dynamic>().firstWhere(
        (k) => k.anggotaKeluarga.any((a) => currentUser != null && (
          a.namaLengkap.toLowerCase() == currentUser.namaLengkap.toLowerCase() ||
          a.nik == currentUser.nik ||
          a.nik == currentUser.username
        )),
        orElse: () => null,
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Data Pribadi Warga Desa Japan",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Data pribadi & status penerima bantuan hibah keluarga Anda (Akses Lihat Data).",
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.textMedium,
            ),
          ),
          const SizedBox(height: 24),

          if (keluarga != null) ...[
            // Main Info Box
            Container(
              constraints: const BoxConstraints(maxWidth: 640),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.015),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    keluarga.namaKepalaKeluarga,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlueDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Desa ${keluarga.desa}, Alamat: RT ${keluarga.rt} / RW ${keluarga.rw} • NIK Head: ${keluarga.nikHead}",
                    style: const TextStyle(fontSize: 13, color: AppTheme.textMedium),
                  ),
                  const Divider(height: 32, color: AppTheme.borderColor),
                  
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow("Dawis Daerah:", keluarga.dawis),
                            _buildInfoRow("Balita:", "${keluarga.totalBalita}"),
                            _buildInfoRow("Sumber Air:", keluarga.sumberAir),
                            _buildInfoRow("Makanan Pokok:", keluarga.makananPokok),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow("Total Anggota:", "${keluarga.totalAnggota} (L:${keluarga.jumlahLakiLaki}, P:${keluarga.jumlahPerempuan})"),
                            _buildInfoRow("Lansia:", "${keluarga.jumlahLansia}"),
                            _buildInfoRow("Status Bantuan:", keluarga.isPenerimaBantuan ? "Ya (Penerima)" : "Tidak"),
                            _buildInfoRow("Nama Bantuan Hibah:", "${keluarga.namaBantuanHibah} (Diisi Kades)"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Read-Only Anggota Keluarga List Table
            Container(
              constraints: const BoxConstraints(maxWidth: 640),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.015),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.people_outline_rounded, color: AppTheme.primaryBlue, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Daftar Anggota Keluarga (Read-Only)",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Table(
                      border: TableBorder.all(color: AppTheme.borderColor, width: 0.8),
                      children: [
                        const TableRow(
                          decoration: BoxDecoration(color: AppTheme.softBlueBg),
                          children: [
                            Padding(padding: EdgeInsets.all(10), child: Text("NIK", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                            Padding(padding: EdgeInsets.all(10), child: Text("Nama", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                            Padding(padding: EdgeInsets.all(10), child: Text("Hubungan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                            Padding(padding: EdgeInsets.all(10), child: Text("JK", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                            Padding(padding: EdgeInsets.all(10), child: Text("Usia", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                          ],
                        ),
                        ...keluarga.anggotaList.map((a) => TableRow(
                          children: [
                            Padding(padding: const EdgeInsets.all(10), child: Text(a.nik, style: const TextStyle(fontSize: 12))),
                            Padding(padding: const EdgeInsets.all(10), child: Text(a.nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                            Padding(padding: const EdgeInsets.all(10), child: Text(a.hubungan, style: const TextStyle(fontSize: 12))),
                            Padding(padding: const EdgeInsets.all(10), child: Text(a.jenisKelamin, style: const TextStyle(fontSize: 12))),
                            Padding(padding: const EdgeInsets.all(10), child: Text("${a.usia} Thn", style: const TextStyle(fontSize: 12))),
                          ],
                        )).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: AppTheme.textDark),
          children: [
            TextSpan(text: "$label ", style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
