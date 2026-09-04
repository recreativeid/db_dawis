import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../warga/providers/warga_provider.dart';
import '../../kades/providers/dashboard_provider.dart';

class ManajemenWargaPage extends StatefulWidget {
  const ManajemenWargaPage({super.key});

  @override
  State<ManajemenWargaPage> createState() => _ManajemenWargaPageState();
}

class _ManajemenWargaPageState extends State<ManajemenWargaPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WargaProvider>().fetchKeluarga();
    });
  }

  void _showEditDialog(Map<String, dynamic> data) {
    final namaCtrl = TextEditingController(text: data['nama_lengkap'].toString());
    final nikCtrl = TextEditingController(text: data['nik'].toString());
    String kriteriaRumah = data['kriteria_rumah']?.toString() ?? 'Sehat Layak Huni';
    
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Edit Data Warga",
          style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaCtrl, 
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  hintText: 'Nama lengkap warga',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nikCtrl, 
                decoration: const InputDecoration(
                  labelText: 'NIK',
                  hintText: 'Nomor Induk Kependudukan',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: kriteriaRumah,
                decoration: const InputDecoration(
                  labelText: "Kriteria Rumah",
                ),
                dropdownColor: Colors.white,
                items: ['Sehat Layak Huni', 'Tidak Sehat Layak Huni'].map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
                onChanged: (val) => kriteriaRumah = val!,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), 
            child: const Text("Batal", style: TextStyle(color: AppTheme.textMedium)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              final updateData = {
                'nama_lengkap': namaCtrl.text,
                'nik': nikCtrl.text,
                'kriteria_rumah': kriteriaRumah,
                'keluarga_id': data['keluarga_id'],
              };
              
              final provider = ctx.read<WargaProvider>();
              final success = await provider.updateKeluarga(data['anggota_id'].toString(), updateData);
              
              if (!ctx.mounted) return;
              Navigator.pop(ctx);
              
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text(success ? 'Berhasil diperbarui' : 'Gagal memperbarui data'),
                  backgroundColor: success ? AppTheme.successGreen : AppTheme.dangerRed,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            child: const Text("Simpan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> data) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppTheme.dangerRed),
            SizedBox(width: 8),
            Text("Hapus Keluarga?", style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          ],
        ),
        content: Text(
          "Yakin ingin menghapus seluruh keluarga dengan KK ${data['no_kk']}? Data anggota keluarga juga akan terhapus secara permanen.",
          style: const TextStyle(color: AppTheme.textMedium),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), 
            child: const Text("Batal", style: TextStyle(color: AppTheme.textMedium)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.dangerRed,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              final provider = ctx.read<WargaProvider>();
              final dashboardProvider = ctx.read<DashboardProvider>();
              
              final success = await provider.hapusKeluarga(data['keluarga_id'].toString());
              
              if (!ctx.mounted) return;
              Navigator.pop(ctx);
              
              dashboardProvider.fetchStatistik(); // Update statistik
              
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text(success ? 'Berhasil dihapus' : 'Gagal dihapus'),
                  backgroundColor: success ? AppTheme.successGreen : AppTheme.dangerRed,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
          "Manajemen Warga",
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

          final list = provider.keluargaList;

          if (list.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada data warga.",
                style: TextStyle(color: AppTheme.textMedium, fontWeight: FontWeight.bold),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.015),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                  border: Border.all(color: Colors.grey.withOpacity(0.05)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  title: Text(
                    item['nama_lengkap'].toString(), 
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark, fontSize: 15)
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      "No. KK: ${item['no_kk']}\nStatus: ${item['status_keluarga']}",
                      style: const TextStyle(color: AppTheme.textMedium, fontSize: 12, height: 1.4),
                    ),
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.edit_rounded, color: AppTheme.primaryBlue, size: 20),
                          onPressed: () => _showEditDialog(item),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.dangerRed.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.delete_rounded, color: AppTheme.dangerRed, size: 20),
                          onPressed: () => _showDeleteDialog(item),
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
}
