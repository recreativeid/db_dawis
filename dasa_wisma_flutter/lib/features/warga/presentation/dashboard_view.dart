import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/app_provider.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Title and Filter Box
          if (isDesktop)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Dashboard Utama - Desa Japan",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                ),
                
                // Filter Wilayah Box
                _buildFilterCard(context, provider),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Dashboard Utama - Desa Japan",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                _buildFilterCard(context, provider),
              ],
            ),
          
          const SizedBox(height: 24),

          // Stat Cards Grid
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 1000 ? 4 : (constraints.maxWidth > 600 ? 2 : 1);
              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStatCard(
                    title: "Total Warga",
                    value: provider.totalWarga.toString(),
                    icon: Icons.person_outline_rounded,
                    bgColor: AppTheme.softBlueBg,
                    iconColor: AppTheme.softBlueText,
                  ),
                  _buildStatCard(
                    title: "Balita",
                    value: provider.totalBalita.toString(),
                    icon: Icons.face_rounded,
                    bgColor: AppTheme.softGreenBg,
                    iconColor: AppTheme.softGreenText,
                  ),
                  _buildStatCard(
                    title: "Lansia",
                    value: provider.totalLansia.toString(),
                    icon: Icons.favorite_border_rounded,
                    bgColor: AppTheme.softYellowBg,
                    iconColor: AppTheme.softYellowText,
                  ),
                  _buildStatCard(
                    title: "Total KK",
                    value: provider.totalKK.toString(),
                    icon: Icons.description_outlined,
                    bgColor: AppTheme.softPurpleBg,
                    iconColor: AppTheme.softPurpleText,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterCard(BuildContext context, AppProvider provider) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(16),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "FILTER WILAYAH",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.textMedium,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          
          // Dropdown 1: Desa
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: provider.selectedDesa,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.textMedium),
                style: const TextStyle(fontSize: 13, color: AppTheme.textDark, fontWeight: FontWeight.w500),
                onChanged: (val) {
                  if (val != null) provider.setSelectedDesa(val);
                },
                items: ['Desa Japan', 'Desa Kudus', 'Desa Muria'].map((d) {
                  return DropdownMenuItem(value: d, child: Text(d));
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          
          // Dropdown 2: Dawis
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: provider.selectedDawis,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.textMedium),
                style: const TextStyle(fontSize: 13, color: AppTheme.textDark, fontWeight: FontWeight.w500),
                onChanged: (val) {
                  if (val != null) provider.setSelectedDawis(val);
                },
                items: ['Semua Dawis', 'dahlia 9', 'dahlia 1', 'mawar 2'].map((d) {
                  return DropdownMenuItem(value: d, child: Text(d));
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Icon Box
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          
          // Text Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textMedium,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
