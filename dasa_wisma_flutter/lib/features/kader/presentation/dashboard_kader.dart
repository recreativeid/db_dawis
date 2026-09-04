import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'form_tambah_keluarga.dart';
import 'manajemen_warga_page.dart';

class DashboardKader extends StatelessWidget {
  const DashboardKader({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text(
          "Dashboard Kader",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: AppTheme.textDark),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppTheme.dangerRed),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          )
        ]
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryBlue, AppTheme.accentBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Selamat Datang,",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Kader",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  "Petugas Dawis",
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Kelola pendataan warga, kriteria rumah tangga, dan usulan bantuan sosial di sini.",
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          const Text(
            "Menu Manajemen",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark),
          ),
          const SizedBox(height: 12),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: [
              _buildMenuCard(
                context, 
                "Manajemen Warga", 
                "KK & Anggota",
                Icons.family_restroom_rounded, 
                AppTheme.primaryBlue, 
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ManajemenWargaPage()));
                }
              ),
              _buildMenuCard(
                context, 
                "Manajemen Dawis", 
                "Wilayah Dasawisma",
                Icons.map_rounded, 
                AppTheme.accentBlue
              ),
              _buildMenuCard(
                context, 
                "Input Bantuan", 
                "Usulan Penerima",
                Icons.edit_document, 
                AppTheme.successGreen
              ),
              _buildMenuCard(
                context, 
                "Rekap Data", 
                "Laporan Lengkap",
                Icons.analytics_rounded, 
                AppTheme.warningOrange
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: const Text("Tambah KK Baru", style: TextStyle(fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const FormTambahKeluarga()));
        },
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, 
    String title, 
    String subtitle,
    IconData icon, 
    Color color, 
    {VoidCallback? onTap}
  ) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap ?? () {}, 
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 28, color: color),
                ),
                const SizedBox(height: 12),
                Text(
                  title, 
                  textAlign: TextAlign.center, 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textDark)
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle, 
                  textAlign: TextAlign.center, 
                  style: const TextStyle(fontSize: 10, color: AppTheme.textLight, fontWeight: FontWeight.w600)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
