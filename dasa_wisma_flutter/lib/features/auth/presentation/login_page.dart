import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/app_provider.dart';
import '../../dashboard/presentation/main_layout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void _openWargaRegisterDialog(BuildContext context) {
    final nikCtrl = TextEditingController(text: '3319011205800002');
    final namaCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();
    String errorMsg = '';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: const [
              Icon(Icons.person_add_alt_1_rounded, color: AppTheme.primaryBlue, size: 24),
              SizedBox(width: 10),
              Text(
                "Buat Password Warga Baru",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppTheme.textDark),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Container(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Gunakan NIK Anda untuk membuat atau memperbarui kata sandi akun warga secara mandiri.",
                    style: TextStyle(fontSize: 12, color: AppTheme.textMedium, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nikCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "NIK (16 Digit)*",
                      hintText: "Masukkan 16 digit NIK",
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: namaCtrl,
                    decoration: const InputDecoration(
                      labelText: "Nama Lengkap",
                      hintText: "Nama sesuai KTP",
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Kata Sandi Baru*",
                      prefixIcon: Icon(Icons.key_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: confirmPassCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Konfirmasi Kata Sandi*",
                      prefixIcon: Icon(Icons.key_rounded),
                    ),
                  ),
                  if (errorMsg.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      errorMsg,
                      style: const TextStyle(color: AppTheme.dangerRed, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
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
                final nik = nikCtrl.text.trim();
                final nama = namaCtrl.text.trim();
                final pass = passCtrl.text.trim();
                final confirm = confirmPassCtrl.text.trim();

                if (nik.isEmpty || pass.isEmpty) {
                  setDialogState(() => errorMsg = "NIK dan Password tidak boleh kosong!");
                  return;
                }
                if (pass != confirm) {
                  setDialogState(() => errorMsg = "Konfirmasi kata sandi tidak cocok!");
                  return;
                }

                context.read<AppProvider>().registerWargaPassword(
                      nik: nik,
                      namaLengkap: nama,
                      password: pass,
                    );

                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Kata sandi untuk NIK $nik berhasil disimpan! Silakan masuk."),
                    backgroundColor: AppTheme.softGreenText,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.softGreenText,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("SIMPAN PASSWORD"),
            ),
          ],
        ),
      ),
    );
  }

  void _openRoleLoginForm(BuildContext context, UserRole role) {
    String defaultUser = role == UserRole.warga ? '3319011205800002' : (role == UserRole.kader ? 'kader' : 'kades');
    String roleTitle = 'Warga';
    
    if (role == UserRole.kader) {
      roleTitle = 'Kader Dasa Wisma';
    } else if (role == UserRole.kades) {
      roleTitle = 'Kepala Desa';
    }

    final userCtrl = TextEditingController(text: defaultUser);
    final passCtrl = TextEditingController(text: '123');
    String errorMsg = '';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.lock_outline_rounded, color: AppTheme.primaryBlue, size: 24),
              const SizedBox(width: 10),
              Text(
                "Masuk - $roleTitle",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.textDark),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                role == UserRole.warga
                    ? "Masukkan Email atau NIK (Nomor Induk Kependudukan) dan kata sandi Anda."
                    : "Masukkan username dan kata sandi Anda untuk melanjutkan.",
                style: const TextStyle(fontSize: 13, color: AppTheme.textMedium),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: userCtrl,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: role == UserRole.warga ? "Email / NIK Warga" : "Username",
                  prefixIcon: Icon(role == UserRole.warga ? Icons.email_outlined : Icons.person_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Kata Sandi",
                  prefixIcon: Icon(Icons.key_outlined),
                ),
              ),
              if (role == UserRole.warga) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(ctx);
                      _openWargaRegisterDialog(context);
                    },
                    child: const Text(
                      "Belum punya password? Buat sendiri di sini",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
              if (errorMsg.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  errorMsg,
                  style: const TextStyle(color: AppTheme.dangerRed, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                final inputUser = userCtrl.text.trim();
                final inputPass = passCtrl.text.trim();

                final authenticatedUser = context.read<AppProvider>().authenticateUser(inputUser, inputPass, role);

                if (authenticatedUser != null) {
                  Navigator.pop(ctx);
                  context.read<AppProvider>().selectRole(role);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MainLayout()),
                  );
                } else {
                  setDialogState(() {
                    errorMsg = "Kredensial salah! Periksa NIK/Username & Kata Sandi.";
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("MASUK"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App Icon Header
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryBlue.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.home_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // App Title
                  const Text(
                    "Sistem Informasi Dasa Wisma -",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                      height: 1.2,
                    ),
                  ),
                  const Text(
                    "Desa Japan",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Subtitle Instruction
                  const Text(
                    "Masuk ke Dashboard Sistem Informasi Dasa Japan dengan memilih salah satu peran di bawah ini.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textMedium,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Role Cards Stack
                  _buildRoleCard(
                    context: context,
                    role: UserRole.warga,
                    title: "Masuk sebagai Warga",
                    subtitle: "Login NIK & buat password mandiri",
                    icon: Icons.person_outline_rounded,
                    bgColor: const Color(0xFFECFDF5),
                    iconColor: const Color(0xFF10B981),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildRoleCard(
                    context: context,
                    role: UserRole.kader,
                    title: "Masuk sebagai Kader",
                    subtitle: "Kelola data Dasa Wisma & user kependudukan",
                    icon: Icons.assignment_outlined,
                    bgColor: const Color(0xFFFEF3C7),
                    iconColor: const Color(0xFFF59E0B),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildRoleCard(
                    context: context,
                    role: UserRole.kades,
                    title: "Masuk sebagai Kepala Desa",
                    subtitle: "Pantau wilayah, kelola akun & bantuan hibah",
                    icon: Icons.shield_outlined,
                    bgColor: const Color(0xFFF3E8FF),
                    iconColor: const Color(0xFF8B5CF6),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required BuildContext context,
    required UserRole role,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openRoleLoginForm(context, role),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
            children: [
              // Icon Container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              
              // Text Information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
