import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/app_provider.dart';
import '../../warga/presentation/dashboard_view.dart';
import '../../warga/presentation/data_pribadi_view.dart';
import '../../warga/presentation/rekap_data_view.dart';
import '../../kader/presentation/manajemen_kk_view.dart';
import '../../kader/presentation/manajemen_user_view.dart';
import '../../kader/presentation/buat_akun_warga_view.dart';
import '../../kades/presentation/manajemen_bantuan_view.dart';
import '../../auth/presentation/login_page.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final activeMenu = provider.activeMenu;
    final isCollapsed = provider.isSidebarCollapsed;

    Widget currentBody;
    switch (activeMenu) {
      case 'data_pribadi':
        currentBody = const DataPribadiView();
        break;
      case 'rekap_data':
        currentBody = const RekapDataView();
        break;
      case 'manajemen_kk':
        currentBody = const ManajemenKkView();
        break;
      case 'manajemen_user':
        currentBody = const ManajemenUserView();
        break;
      case 'buat_akun_warga':
        currentBody = const BuatAkunWargaView();
        break;
      case 'manajemen_bantuan':
        currentBody = const ManajemenBantuanView();
        break;
      case 'dashboard':
      default:
        currentBody = const DashboardView();
        break;
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar / Header
            _buildTopAppBar(context, provider),
            
            // Body Content with Left Sidebar & Main Panel
            Expanded(
              child: Stack(
                children: [
                  Row(
                    children: [
                      // Sidebar Navigation Panel
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isCollapsed ? 76 : 230,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            right: BorderSide(color: AppTheme.borderColor, width: 1),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            Expanded(
                              child: ListView(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                children: _buildSidebarItems(context, provider),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Main Content Area
                      Expanded(
                        child: currentBody,
                      ),
                    ],
                  ),

                  // Floating Collapse Toggle Button on Sidebar Border
                  Positioned(
                    top: 24,
                    left: isCollapsed ? 60 : 214,
                    child: GestureDetector(
                      onTap: () => provider.toggleSidebar(),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryBlue.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isCollapsed ? Icons.chevron_right_rounded : Icons.chevron_left_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Top App Bar Matching Canva UI
  Widget _buildTopAppBar(BuildContext context, AppProvider provider) {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Logo & Title
          Row(
            children: [
              // Icon Badge
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.home_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              
              // App Titles
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sistem Informasi Dasa Wisma Desa Japan",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: const [
                      Icon(Icons.location_on_outlined, size: 12, color: AppTheme.primaryBlue),
                      SizedBox(width: 3),
                      Text(
                        "Desa: Japan",
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Right Navigation & Actions
          Row(
            children: [
              // Role Toggle Buttons Group (Pills)
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: Row(
                  children: [
                    _buildRolePill(context, provider, UserRole.warga, "Warga"),
                    const SizedBox(width: 4),
                    _buildRolePill(context, provider, UserRole.kader, "Kader"),
                    const SizedBox(width: 4),
                    _buildRolePill(context, provider, UserRole.kades, "Kepala Desa"),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // Logout / Exit Button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.borderColor),
                    ),
                    child: const Icon(
                      Icons.exit_to_app_rounded,
                      color: AppTheme.textMedium,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRolePill(BuildContext context, AppProvider provider, UserRole role, String label) {
    final isSelected = provider.activeRole == role;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => provider.selectRole(role),
        borderRadius: BorderRadius.circular(9),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : AppTheme.textDark,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSidebarItems(BuildContext context, AppProvider provider) {
    final role = provider.activeRole;
    final activeMenu = provider.activeMenu;
    final isCollapsed = provider.isSidebarCollapsed;

    List<Map<String, dynamic>> items = [];

    if (role == UserRole.warga) {
      items = [
        {'key': 'dashboard', 'label': 'Dashboard', 'icon': Icons.grid_view_rounded},
        {'key': 'data_pribadi', 'label': 'Data Pribadi', 'icon': Icons.person_outline_rounded},
        {'key': 'rekap_data', 'label': 'Rekap Data', 'icon': Icons.description_outlined},
      ];
    } else if (role == UserRole.kader) {
      items = [
        {'key': 'dashboard', 'label': 'Dashboard', 'icon': Icons.grid_view_rounded},
        {'key': 'manajemen_kk', 'label': 'Manajemen KK', 'icon': Icons.people_outline_rounded},
        {'key': 'buat_akun_warga', 'label': 'Buat Akun Warga', 'icon': Icons.person_add_alt_1_outlined},
        {'key': 'manajemen_user', 'label': 'Manajemen User', 'icon': Icons.admin_panel_settings_outlined},
        {'key': 'rekap_data', 'label': 'Rekap Data', 'icon': Icons.description_outlined},
      ];
    } else {
      // Kepala Desa
      items = [
        {'key': 'dashboard', 'label': 'Dashboard', 'icon': Icons.grid_view_rounded},
        {'key': 'manajemen_bantuan', 'label': 'Manajemen Bantuan', 'icon': Icons.shopping_bag_outlined},
        {'key': 'manajemen_user', 'label': 'Manajemen User', 'icon': Icons.admin_panel_settings_outlined},
      ];
    }

    return items.map((item) {
      final isSelected = activeMenu == item['key'];
      return Container(
        margin: const EdgeInsets.only(bottom: 6),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => provider.setActiveMenu(item['key'] as String),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isCollapsed ? 12 : 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
                children: [
                  Icon(
                    item['icon'] as IconData,
                    color: isSelected ? Colors.white : AppTheme.textMedium,
                    size: 20,
                  ),
                  if (!isCollapsed) ...[
                    const SizedBox(width: 14),
                    Text(
                      item['label'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.white : AppTheme.textDark,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}
