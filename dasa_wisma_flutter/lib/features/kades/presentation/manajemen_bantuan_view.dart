import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/app_provider.dart';

class ManajemenBantuanView extends StatefulWidget {
  const ManajemenBantuanView({super.key});

  @override
  State<ManajemenBantuanView> createState() => _ManajemenBantuanViewState();
}

class _ManajemenBantuanViewState extends State<ManajemenBantuanView> {
  final TextEditingController _tagController = TextEditingController();

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  void _showAddBantuanModal() {
    final provider = context.read<AppProvider>();
    final kkList = provider.keluargaList;
    if (kkList.isEmpty) return;

    String selectedKk = kkList.first.namaKepalaKeluarga;
    String selectedBantuan = provider.bantuanTags.isNotEmpty ? provider.bantuanTags.first : 'PKH';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Tambah Data Bantuan", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedKk,
                decoration: const InputDecoration(labelText: "Nama Kepala Keluarga"),
                items: kkList.map((k) => DropdownMenuItem(value: k.namaKepalaKeluarga, child: Text(k.namaKepalaKeluarga))).toList(),
                onChanged: (val) => setDialogState(() => selectedKk = val!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedBantuan,
                decoration: const InputDecoration(labelText: "Jenis Bantuan"),
                items: provider.bantuanTags.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                onChanged: (val) => setDialogState(() => selectedBantuan = val!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                provider.addBantuanRecord(selectedKk, selectedBantuan);
                Navigator.pop(ctx);
              },
              child: const Text("Tambah"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final bantuanList = provider.bantuanList;
    final tags = provider.bantuanTags;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Title
          const Text(
            "Manajemen Bantuan Hibah - Desa Japan",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 20),

          // Control Bar: Add Button + Tag Input
          Wrap(
            spacing: 16,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _showAddBantuanModal,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text("Tambah Bantuan"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.softGreenText,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Nama Bantuan Tersedia: ",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 220,
                    height: 42,
                    child: TextField(
                      controller: _tagController,
                      decoration: InputDecoration(
                        hintText: "Tambah nama bantuan...",
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_tagController.text.trim().isNotEmpty) {
                        provider.addBantuanTag(_tagController.text.trim());
                        _tagController.clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Tambah"),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Tag Pills
          Wrap(
            spacing: 8,
            children: tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.softBlueBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.accentBlue.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tag,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.softBlueText),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => provider.removeBantuanTag(tag),
                      child: const Icon(Icons.close_rounded, size: 14, color: AppTheme.softBlueText),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Data Table
          Container(
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
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(60),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FixedColumnWidth(100),
                },
                children: [
                  // Table Header
                  TableRow(
                    decoration: const BoxDecoration(color: AppTheme.softBlueBg),
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Text("No", style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Text("Kepala Keluarga", style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Text("Nama Bantuan", style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Text("Aksi", style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                      ),
                    ],
                  ),
                  // Table Rows
                  ...bantuanList.asMap().entries.map((entry) {
                    final index = entry.key + 1;
                    final item = entry.value;
                    return TableRow(
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: AppTheme.borderColor, width: 0.8)),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Text("$index", style: const TextStyle(fontSize: 13)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Text(item.namaKepalaKeluarga, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Text(item.namaBantuan, style: const TextStyle(fontSize: 13)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: InkWell(
                            onTap: () => provider.deleteBantuanRecord(item.id),
                            child: const Text(
                              "Hapus",
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.dangerRed),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
