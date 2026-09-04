import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/models/dasa_wisma_model.dart';

class ManajemenUserView extends StatefulWidget {
  const ManajemenUserView({super.key});

  @override
  State<ManajemenUserView> createState() => _ManajemenUserViewState();
}

class _ManajemenUserViewState extends State<ManajemenUserView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddEditUserDialog([UserModel? user]) {
    final isEdit = user != null;
    final usernameCtrl = TextEditingController(text: user?.username ?? '');
    final namaCtrl = TextEditingController(text: user?.namaLengkap ?? '');
    final passCtrl = TextEditingController(text: user?.password ?? '');
    String roleStr = user?.role ?? 'warga';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(isEdit ? Icons.edit_rounded : Icons.person_add_rounded, color: AppTheme.primaryBlue),
              const SizedBox(width: 10),
              Text(
                isEdit ? "Edit Akun User" : "Tambah Akun User Baru",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.textDark),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: roleStr,
                    decoration: const InputDecoration(
                      labelText: "Peran / Role Pengguna",
                      prefixIcon: Icon(Icons.security_rounded),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'warga', child: Text("Warga Desa")),
                      DropdownMenuItem(value: 'kader', child: Text("Kader Dasa Wisma")),
                      DropdownMenuItem(value: 'kades', child: Text("Kepala Desa")),
                    ],
                    onChanged: (val) => setDialogState(() => roleStr = val!),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: usernameCtrl,
                    decoration: InputDecoration(
                      labelText: roleStr == 'warga' ? "NIK / Username" : "Username",
                      hintText: roleStr == 'warga' ? "Masukkan 16 digit NIK" : "Masukkan username",
                      prefixIcon: const Icon(Icons.badge_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: namaCtrl,
                    decoration: const InputDecoration(
                      labelText: "Nama Lengkap",
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: passCtrl,
                    obscureText: false,
                    decoration: const InputDecoration(
                      labelText: "Kata Sandi / Password",
                      prefixIcon: Icon(Icons.key_outlined),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                final username = usernameCtrl.text.trim();
                final nama = namaCtrl.text.trim();
                final pass = passCtrl.text.trim();

                if (username.isEmpty || pass.isEmpty || nama.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Semua field wajib diisi!")),
                  );
                  return;
                }

                final provider = context.read<AppProvider>();

                if (isEdit) {
                  provider.updateUser(UserModel(
                    id: user.id,
                    username: username,
                    password: pass,
                    namaLengkap: nama,
                    role: roleStr,
                    nik: roleStr == 'warga' ? username : null,
                  ));
                } else {
                  provider.addUser(UserModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    username: username,
                    password: pass,
                    namaLengkap: nama,
                    role: roleStr,
                    nik: roleStr == 'warga' ? username : null,
                  ));
                }

                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isEdit ? "Akun berhasil diperbarui!" : "Akun user baru berhasil ditambahkan!"),
                    backgroundColor: AppTheme.softGreenText,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(isEdit ? "Simpan Perubahan" : "Tambah User"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final users = provider.userList.where((u) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return u.username.toLowerCase().contains(q) ||
          u.namaLengkap.toLowerCase().contains(q) ||
          u.role.toLowerCase().contains(q);
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Manajemen Akun & Pengguna - Desa Japan",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Kader dan Kepala Desa mampu membuat, mengatur NIK, username, dan kata sandi akun warga.",
                    style: TextStyle(fontSize: 13, color: AppTheme.textMedium),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddEditUserDialog(),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text("Tambah User Baru"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.softGreenText,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Search Filter Bar
          SizedBox(
            width: 320,
            height: 44,
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: "Cari username, NIK, atau nama...",
                hintStyle: const TextStyle(fontSize: 13, color: AppTheme.textMedium),
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.borderColor)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.borderColor)),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Users Table Container
          Container(
            width: double.infinity,
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(AppTheme.softBlueBg),
                headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark, fontSize: 13),
                dataTextStyle: const TextStyle(fontSize: 13, color: AppTheme.textDark),
                columns: const [
                  DataColumn(label: Text("No")),
                  DataColumn(label: Text("Username / NIK")),
                  DataColumn(label: Text("Nama Lengkap")),
                  DataColumn(label: Text("Peran / Role")),
                  DataColumn(label: Text("Kata Sandi")),
                  DataColumn(label: Text("Aksi")),
                ],
                rows: users.asMap().entries.map((entry) {
                  final idx = entry.key + 1;
                  final u = entry.value;

                  Color badgeBg = const Color(0xFFECFDF5);
                  Color badgeText = const Color(0xFF10B981);
                  String roleLabel = "Warga";

                  if (u.role == 'kader') {
                    badgeBg = const Color(0xFFFEF3C7);
                    badgeText = const Color(0xFFF59E0B);
                    roleLabel = "Kader Dasa Wisma";
                  } else if (u.role == 'kades') {
                    badgeBg = const Color(0xFFF3E8FF);
                    badgeText = const Color(0xFF8B5CF6);
                    roleLabel = "Kepala Desa";
                  }

                  return DataRow(
                    cells: [
                      DataCell(Text("$idx")),
                      DataCell(
                        Text(
                          u.username,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryBlueDark),
                        ),
                      ),
                      DataCell(Text(u.namaLengkap)),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: badgeBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            roleLabel,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: badgeText),
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            const Icon(Icons.key_outlined, size: 14, color: AppTheme.textMedium),
                            const SizedBox(width: 4),
                            Text(u.password, style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            InkWell(
                              onTap: () => _showAddEditUserDialog(u),
                              child: const Text("Edit", style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 14),
                            InkWell(
                              onTap: () => provider.deleteUser(u.id),
                              child: const Text("Hapus", style: TextStyle(color: AppTheme.dangerRed, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
