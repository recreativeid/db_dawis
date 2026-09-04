import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/warga_provider.dart';

class DataPribadiWarga extends StatefulWidget {
  const DataPribadiWarga({super.key});

  @override
  State<DataPribadiWarga> createState() => _DataPribadiWargaState();
}

class _DataPribadiWargaState extends State<DataPribadiWarga> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WargaProvider>().fetchKeluarga();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text(
          "Data Pribadi & Keluarga",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppTheme.textDark),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppTheme.primaryBlue),
            onPressed: () => context.read<WargaProvider>().fetchKeluarga(),
          )
        ],
      ),
      body: Consumer<WargaProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (provider.error.isNotEmpty) {
            return Center(child: Text('Error: ${provider.error}'));
          }

          final keluargaList = provider.keluargaList;

          if (keluargaList.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada data keluarga",
                style: TextStyle(color: AppTheme.textMedium, fontWeight: FontWeight.bold),
              ),
            );
          }

          // Asumsikan data pertama adalah data warga yang login saat ini
          final data = keluargaList.first;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader("Informasi Kepala Keluarga"),
                const SizedBox(height: 8),
                _buildInfoCard([
                  _buildInfoRow("NO KK", data['no_kk'].toString(), Icons.assignment_rounded),
                  _buildInfoRow("NIK", data['nik'].toString(), Icons.badge_rounded),
                  _buildInfoRow("Nama Lengkap", data['nama_lengkap'].toString(), Icons.person_rounded),
                  _buildInfoRow("Status Keluarga", data['status_keluarga'].toString(), Icons.family_restroom_rounded),
                  _buildInfoRow("Kriteria Rumah", data['kriteria_rumah']?.toString() ?? '-', Icons.home_work_rounded, highlight: true),
                ]),
                const SizedBox(height: 28),
                _buildSectionHeader("Daftar Anggota Keluarga"),
                const SizedBox(height: 8),
                ...keluargaList.map((anggota) => _buildAnggotaKeluargaCard(
                  anggota['nama_lengkap'].toString(), 
                  anggota['status_keluarga'].toString(), 
                  anggota['nik'].toString(), 
                  "-", // Gender belum ada di response JOIN
                  "-"  // Umur belum dihitung di response
                )).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppTheme.textDark,
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppTheme.textLight),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.textMedium,
                fontSize: 13,
              ),
            ),
          ),
          const Text(" ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: highlight 
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: value.toLowerCase().contains("tidak") 
                          ? AppTheme.dangerRed.withOpacity(0.1) 
                          : AppTheme.softGreenText.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      value,
                      style: TextStyle(
                        color: value.toLowerCase().contains("tidak") ? AppTheme.dangerRed : AppTheme.softGreenText,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  )
                : Text(
                    value,
                    style: const TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnggotaKeluargaCard(String nama, String hubungan, String nik, String jk, String usia) {
    bool isKepalaKeluarga = hubungan.toLowerCase().contains("kepala");
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isKepalaKeluarga ? AppTheme.primaryBlue.withOpacity(0.1) : AppTheme.accentBlue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isKepalaKeluarga ? Icons.admin_panel_settings_rounded : Icons.person_rounded,
            color: isKepalaKeluarga ? AppTheme.primaryBlue : AppTheme.accentBlue,
          ),
        ),
        title: Text(nama, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
        subtitle: Text(
          "$hubungan • NIK: $nik",
          style: const TextStyle(color: AppTheme.textMedium, fontSize: 12),
        ),
      ),
    );
  }
}
