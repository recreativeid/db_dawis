import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import 'data_pribadi_warga.dart';
import '../../kades/providers/dashboard_provider.dart';

class DashboardWarga extends StatefulWidget {
  const DashboardWarga({super.key});

  @override
  State<DashboardWarga> createState() => _DashboardWargaState();
}

class _DashboardWargaState extends State<DashboardWarga> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchStatistik();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text(
          "Dashboard Warga",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: AppTheme.textDark),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppTheme.primaryBlue),
            onPressed: () => context.read<DashboardProvider>().fetchStatistik(),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppTheme.dangerRed),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          )
        ],
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (provider.error.isNotEmpty) {
            return Center(child: Text('Error: ${provider.error}'));
          }

          final stat = provider.statistik;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              // Welcome Header Card
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
                            "Warga",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Keluarga Dawis",
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Pantau statistik wilayah dan status bantuan sosial Anda di sini.",
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              const Text(
                "Statistik Wilayah",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark),
              ),
              const SizedBox(height: 12),

              if (stat != null)
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.4,
                  children: [
                    _buildGridCard("Total Warga", stat['total_warga'].toString(), Icons.people_rounded, AppTheme.primaryBlue),
                    _buildGridCard("Total KK", stat['total_kk'].toString(), Icons.family_restroom_rounded, AppTheme.warningOrange),
                    _buildGridCard("Balita", stat['total_balita'].toString(), Icons.child_care_rounded, AppTheme.successGreen),
                    _buildGridCard("Lansia", stat['total_lansia'].toString(), Icons.elderly_rounded, Colors.purple),
                  ],
                ),
              const SizedBox(height: 28),
              
              const Text(
                "Menu Akses Cepat",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark),
              ),
              const SizedBox(height: 12),
              
              // Menu item 1
              Container(
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
                ),
                child: Material(
                  color: Colors.transparent,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person_rounded, color: AppTheme.primaryBlue),
                    ),
                    title: const Text(
                      "Data Pribadi & Keluarga",
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark),
                    ),
                    subtitle: const Text(
                      "Lihat NIK, Alamat, dan Anggota Keluarga",
                      style: TextStyle(color: AppTheme.textMedium, fontSize: 12),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.textLight),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const DataPribadiWarga()));
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Menu item 2
              Container(
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
                ),
                child: Material(
                  color: Colors.transparent,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.card_giftcard_rounded, color: AppTheme.successGreen),
                    ),
                    title: const Text(
                      "Informasi Bantuan Hibah",
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark),
                    ),
                    subtitle: const Text(
                      "Status: Penerima - BLT Dana Desa",
                      style: TextStyle(color: AppTheme.successGreen, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(Icons.info_outline_rounded, size: 16, color: AppTheme.successGreen),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const DataPribadiWarga()));
                    },
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildGridCard(String title, String count, IconData icon, Color color) {
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Text(
                  count, 
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color),
                ),
              ],
            ),
            const Spacer(),
            Text(
              title, 
              style: const TextStyle(color: AppTheme.textMedium, fontSize: 12, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
