import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/models/dasa_wisma_model.dart';

class BuatAkunWargaView extends StatefulWidget {
  const BuatAkunWargaView({super.key});

  @override
  State<BuatAkunWargaView> createState() => _BuatAkunWargaViewState();
}

class _BuatAkunWargaViewState extends State<BuatAkunWargaView> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _namaCtrl = TextEditingController();
  final _nikCtrl = TextEditingController();
  final _dawisCtrl = TextEditingController();
  final _rtCtrl = TextEditingController(text: '1');
  final _rwCtrl = TextEditingController(text: '4');

  String _searchQuery = '';
  String _selectedFilterDawis = 'Semua Dawis';

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _namaCtrl.dispose();
    _nikCtrl.dispose();
    _dawisCtrl.dispose();
    _rtCtrl.dispose();
    _rwCtrl.dispose();
    super.dispose();
  }

  void _onDawisSelected(String dawisName, AppProvider provider) {
    _dawisCtrl.text = dawisName;
    final found = provider.findDawis(dawisName);
    if (found != null) {
      _rtCtrl.text = found.rt;
      _rwCtrl.text = found.rw;
    }
  }

  void _simpanAkunWarga() {
    if (_emailCtrl.text.trim().isEmpty || _passCtrl.text.trim().isEmpty || _namaCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email, Nama, dan Password wajib diisi!"),
          backgroundColor: AppTheme.dangerRed,
        ),
      );
      return;
    }

    final provider = context.read<AppProvider>();
    final dawisName = _dawisCtrl.text.trim();
    final rtVal = _rtCtrl.text.trim().isNotEmpty ? _rtCtrl.text.trim() : '1';
    final rwVal = _rwCtrl.text.trim().isNotEmpty ? _rwCtrl.text.trim() : '4';

    // 1. Simpan/Daftarkan Dawis & RT/RW ke master provider agar otomatis tertambahkan di fitur sortir
    if (dawisName.isNotEmpty) {
      provider.addOrUpdateDawis(
        nama: dawisName,
        rt: rtVal,
        rw: rwVal,
      );
    }

    // 2. Buat akun Warga baru
    provider.createAkunWarga(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text.trim(),
      namaLengkap: _namaCtrl.text.trim(),
      nik: _nikCtrl.text.trim(),
    );

    // 3. Tambah atau perbarui data KK jika nama & Dawis ada
    final existingKk = provider.keluargaList.any(
      (k) => k.namaKepalaKeluarga.toLowerCase() == _namaCtrl.text.trim().toLowerCase() ||
             (k.nikHead.isNotEmpty && k.nikHead == _nikCtrl.text.trim()),
    );

    if (!existingKk && dawisName.isNotEmpty) {
      provider.addKeluarga(
        KeluargaModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          noKk: _nikCtrl.text.trim().isNotEmpty ? "3319${_nikCtrl.text.trim()}" : "331901${DateTime.now().millisecondsSinceEpoch}",
          nikHead: _nikCtrl.text.trim().isNotEmpty ? _nikCtrl.text.trim() : "331901${DateTime.now().millisecondsSinceEpoch}",
          namaKepalaKeluarga: _namaCtrl.text.trim(),
          desa: 'Japan',
          alamat: 'RT $rtVal / RW $rwVal',
          rt: rtVal,
          rw: rwVal,
          dawis: dawisName,
        ),
      );
    }

    _emailCtrl.clear();
    _passCtrl.clear();
    _namaCtrl.clear();
    _nikCtrl.clear();
    _dawisCtrl.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Berhasil membuat akun Warga baru & mendaftarkan Dawis '$dawisName' (RT $rtVal/RW $rwVal)!"),
        backgroundColor: AppTheme.softGreenText,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showEditWargaDialog(UserModel user) {
    final emailCtrl = TextEditingController(text: user.email ?? '');
    final namaCtrl = TextEditingController(text: user.namaLengkap);
    final nikCtrl = TextEditingController(text: user.nik ?? user.username);
    final passCtrl = TextEditingController(text: user.password);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.edit_rounded, color: AppTheme.primaryBlue),
            SizedBox(width: 10),
            Text("Edit Akun Warga", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaCtrl,
                decoration: const InputDecoration(labelText: "Nama Lengkap", prefixIcon: Icon(Icons.person_outline)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nikCtrl,
                decoration: const InputDecoration(labelText: "NIK / ID Warga", prefixIcon: Icon(Icons.badge_outlined)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: "Email Login Warga", prefixIcon: Icon(Icons.email_outlined)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passCtrl,
                decoration: const InputDecoration(labelText: "Kata Sandi / Password", prefixIcon: Icon(Icons.key_outlined)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              context.read<AppProvider>().updateUser(UserModel(
                id: user.id,
                username: nikCtrl.text.trim().isNotEmpty ? nikCtrl.text.trim() : user.username,
                email: emailCtrl.text.trim(),
                password: passCtrl.text.trim(),
                namaLengkap: namaCtrl.text.trim(),
                role: 'warga',
                nik: nikCtrl.text.trim(),
              ));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Akun Warga berhasil diperbarui!"), backgroundColor: AppTheme.softGreenText),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final kkList = provider.keluargaList;
    final allDawisNames = provider.allDawisNames;

    final wargaAccounts = provider.userList.where((u) {
      if (u.role != 'warga') return false;

      // Filter by Dawis if selected
      if (_selectedFilterDawis != 'Semua Dawis') {
        final kkMatch = kkList.firstWhere(
          (k) => k.namaKepalaKeluarga.toLowerCase() == u.namaLengkap.toLowerCase() ||
                 (k.nikHead.isNotEmpty && k.nikHead == (u.nik ?? u.username)),
          orElse: () => KeluargaModel(id: '', namaKepalaKeluarga: '', dawis: ''),
        );
        if (kkMatch.dawis.toLowerCase() != _selectedFilterDawis.toLowerCase()) {
          return false;
        }
      }

      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return u.namaLengkap.toLowerCase().contains(q) ||
          (u.email ?? '').toLowerCase().contains(q) ||
          u.username.toLowerCase().contains(q);
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page Header Title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Buat Akun Login Warga - Desa Japan",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Menu khusus Kader Dasa Wisma untuk mendaftarkan akun login Warga beserta daerah Dasa Wisma & RT/RW otomatis.",
                style: TextStyle(fontSize: 13, color: AppTheme.textMedium),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Form Card: Create New Warga Account & Dawis Area
          Container(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.person_add_alt_1_rounded, color: AppTheme.primaryBlue, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Form Pembuatan Akun Warga Baru & Daerah Dawis",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Quick Select from existing KK list
                if (kkList.isNotEmpty) ...[
                  Row(
                    children: [
                      const Text(
                        "Pilih Kepala Keluarga Terdaftar: ",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textMedium),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.borderColor),
                          color: AppTheme.softBlueBg,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: const Text("Pilih KK...", style: TextStyle(fontSize: 12)),
                            style: const TextStyle(fontSize: 12, color: AppTheme.textDark, fontWeight: FontWeight.w600),
                            onChanged: (val) {
                              if (val != null) {
                                final selected = kkList.firstWhere((k) => k.namaKepalaKeluarga == val);
                                setState(() {
                                  _namaCtrl.text = selected.namaKepalaKeluarga;
                                  _nikCtrl.text = selected.nikHead;
                                  _emailCtrl.text = "${selected.namaKepalaKeluarga.replaceAll(' ', '.').toLowerCase()}@japan.desa.id";
                                  _passCtrl.text = '123456';
                                  _dawisCtrl.text = selected.dawis;
                                  _rtCtrl.text = selected.rt;
                                  _rwCtrl.text = selected.rw;
                                });
                              }
                            },
                            items: kkList.map((k) => DropdownMenuItem(value: k.namaKepalaKeluarga, child: Text("${k.namaKepalaKeluarga} (${k.dawis})"))).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Form Inputs Grid
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                TextField(
                                  controller: _namaCtrl,
                                  decoration: const InputDecoration(
                                    labelText: "Nama Lengkap Warga *",
                                    hintText: "Contoh: Budi Santoso",
                                    prefixIcon: Icon(Icons.person_outline),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                TextField(
                                  controller: _nikCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: "NIK / ID Warga (Opsional)",
                                    hintText: "Masukkan 16 digit NIK",
                                    prefixIcon: Icon(Icons.badge_outlined),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              children: [
                                TextField(
                                  controller: _emailCtrl,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    labelText: "Email Login Warga *",
                                    hintText: "contoh: budi@japan.desa.id",
                                    prefixIcon: Icon(Icons.email_outlined),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                TextField(
                                  controller: _passCtrl,
                                  decoration: const InputDecoration(
                                    labelText: "Kata Sandi / Password *",
                                    hintText: "Buatkan password untuk warga",
                                    prefixIcon: Icon(Icons.key_outlined),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Section Daerah Dawis & Otomatisasi RT/RW
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.softBlueBg.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.location_on_rounded, color: AppTheme.primaryBlue, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  "Pengaturan Daerah Dasa Wisma (Isi Sendiri & Otomatis RT/RW)",
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryBlueDark),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Input / Dropdown Nama Dawis Mandiri
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      LayoutBuilder(
                                        builder: (context, constraints) {
                                          return Autocomplete<String>(
                                            optionsBuilder: (TextEditingValue textEditingValue) {
                                              if (textEditingValue.text.isEmpty) {
                                                return allDawisNames;
                                              }
                                              return allDawisNames.where((String option) {
                                                return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                                              });
                                            },
                                            initialValue: TextEditingValue(text: _dawisCtrl.text),
                                            onSelected: (String selection) {
                                              _onDawisSelected(selection, provider);
                                            },
                                            fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                                              // Sync with _dawisCtrl
                                              textEditingController.addListener(() {
                                                _dawisCtrl.text = textEditingController.text;
                                                final found = provider.findDawis(textEditingController.text);
                                                if (found != null) {
                                                  _rtCtrl.text = found.rt;
                                                  _rwCtrl.text = found.rw;
                                                }
                                              });

                                              return TextField(
                                                controller: textEditingController,
                                                focusNode: focusNode,
                                                decoration: const InputDecoration(
                                                  labelText: "Daerah Dasa Wisma (Ketik Sendiri / Pilih) *",
                                                  hintText: "Ketik nama dawis baru (contoh: Dahlia 3)",
                                                  prefixIcon: Icon(Icons.maps_home_work_outlined),
                                                  helperText: "Ketik nama Dawis baru untuk menambahkan otomatis ke sortir",
                                                  helperStyle: TextStyle(fontSize: 11, color: AppTheme.primaryBlue),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // RT Input
                                Expanded(
                                  child: TextField(
                                    controller: _rtCtrl,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: "RT (Otomatis)",
                                      hintText: "Contoh: 1",
                                      prefixIcon: Icon(Icons.tag_rounded),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // RW Input
                                Expanded(
                                  child: TextField(
                                    controller: _rwCtrl,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: "RW (Otomatis)",
                                      hintText: "Contoh: 4",
                                      prefixIcon: Icon(Icons.pin_outlined),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Submit Button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: _simpanAkunWarga,
                    icon: const Icon(Icons.check_circle_rounded, size: 18),
                    label: const Text("BUAT AKUN WARGA"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.softGreenText,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Registered Warga Accounts Table with Dawis Sort & Search
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Daftar Akun Warga Terdaftar",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark),
              ),
              Wrap(
                spacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [

                  // Fitur Sortir Pilihan Dawis (Dynamic)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.borderColor),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: allDawisNames.contains(_selectedFilterDawis) ? _selectedFilterDawis : 'Semua Dawis',
                        icon: const Icon(Icons.filter_alt_outlined, size: 18, color: AppTheme.primaryBlue),
                        style: const TextStyle(fontSize: 12, color: AppTheme.textDark, fontWeight: FontWeight.w600),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedFilterDawis = val);
                        },
                        items: ['Semua Dawis', ...allDawisNames].map((d) => DropdownMenuItem(
                          value: d,
                          child: Text(d == 'Semua Dawis' ? 'Sortir: Semua Dawis' : 'Dawis: $d'),
                        )).toList(),
                      ),
                    ),
                  ),

                  // Search Box
                  SizedBox(
                    width: 240,
                    height: 40,
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: InputDecoration(
                        hintText: "Cari email, nama, NIK...",
                        hintStyle: const TextStyle(fontSize: 12, color: AppTheme.textMedium),
                        prefixIcon: const Icon(Icons.search_rounded, size: 18),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppTheme.borderColor)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Table Widget
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
                  DataColumn(label: Text("Nama Warga")),
                  DataColumn(label: Text("Email Login")),
                  DataColumn(label: Text("NIK / Username")),
                  DataColumn(label: Text("Kata Sandi")),
                  DataColumn(label: Text("Aksi")),
                ],
                rows: wargaAccounts.asMap().entries.map((entry) {
                  final idx = entry.key + 1;
                  final u = entry.value;

                  return DataRow(
                    cells: [
                      DataCell(Text("$idx")),
                      DataCell(
                        Text(
                          u.namaLengkap,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark),
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            const Icon(Icons.email_outlined, size: 14, color: AppTheme.primaryBlue),
                            const SizedBox(width: 6),
                            Text(
                              u.email ?? '-',
                              style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.primaryBlueDark),
                            ),
                          ],
                        ),
                      ),
                      DataCell(Text(u.nik ?? u.username)),
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
                              onTap: () => _showEditWargaDialog(u),
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

