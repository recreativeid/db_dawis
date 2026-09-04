import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../warga/providers/warga_provider.dart';

class ValidasiBantuanPage extends StatefulWidget {
  const ValidasiBantuanPage({super.key});

  @override
  State<ValidasiBantuanPage> createState() => _ValidasiBantuanPageState();
}

class _ValidasiBantuanPageState extends State<ValidasiBantuanPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WargaProvider>().fetchKeluarga();
    });
  }

  void _showValidasiDialog(BuildContext context, String nama, String anggotaId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.verified_user_rounded, color: AppTheme.successGreen),
            SizedBox(width: 8),
            Text("Konfirmasi Validasi", style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          ],
        ),
        content: Text(
          "Apakah Anda yakin ingin menyetujui bantuan hibah untuk keluarga $nama?",
          style: const TextStyle(color: AppTheme.textMedium),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal", style: TextStyle(color: AppTheme.textMedium)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.successGreen,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              
              final provider = context.read<WargaProvider>();
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              
              final success = await provider.setujuiBantuan(anggotaId);

              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text(
                    success 
                        ? "Bantuan untuk $nama berhasil disetujui!" 
                        : "Gagal menyetujui bantuan untuk $nama. Silakan coba lagi."
                  ),
                  backgroundColor: success ? AppTheme.successGreen : AppTheme.dangerRed,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            child: const Text("Setujui", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text(
          "Validasi Bantuan",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppTheme.textDark),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<WargaProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error.isNotEmpty) {
            return Center(child: Text('Error: ${provider.error}', style: const TextStyle(color: AppTheme.dangerRed)));
          }

          final kepalaKeluargaList = provider.keluargaList
              .where((k) => k['status_keluarga'] == 'Kepala Keluarga')
              .toList();

          if (kepalaKeluargaList.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada data pengajuan dari Kader.",
                style: TextStyle(color: AppTheme.textMedium, fontWeight: FontWeight.bold),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            itemCount: kepalaKeluargaList.length,
            itemBuilder: (context, index) {
              final data = kepalaKeluargaList[index];
              final isPrioritas = data['kriteria_rumah'] == 'Tidak Sehat Layak Huni';

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.015),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                  border: Border.all(color: Colors.grey.withOpacity(0.05)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              data['nama_lengkap'].toString(),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textDark),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isPrioritas ? AppTheme.dangerRed.withOpacity(0.1) : AppTheme.successGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isPrioritas ? "Prioritas" : "Reguler",
                              style: TextStyle(
                                color: isPrioritas ? AppTheme.dangerRed : AppTheme.successGreen,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1, thickness: 1, color: AppTheme.backgroundLight),
                      const SizedBox(height: 12),
                      _buildDetailRow("No KK", data['no_kk'].toString()),
                      _buildDetailRow("NIK", data['nik'].toString()),
                      _buildDetailRow("Kriteria Rumah", data['kriteria_rumah'] ?? '-'),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                          label: const Text("Validasi & Setujui Bantuan"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          onPressed: () => _showValidasiDialog(
                            context, 
                            data['nama_lengkap'],
                            data['anggota_id'].toString() // Asumsi API mengembalikan 'id' sebagai primary key
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppTheme.textMedium, fontWeight: FontWeight.w600),
            ),
          ),
          const Text(": ", style: TextStyle(color: AppTheme.textMedium, fontSize: 12)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, color: AppTheme.textDark, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
