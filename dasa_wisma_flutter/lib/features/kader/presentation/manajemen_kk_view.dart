import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/models/dasa_wisma_model.dart';

class ManajemenKkView extends StatefulWidget {
  const ManajemenKkView({super.key});

  @override
  State<ManajemenKkView> createState() => _ManajemenKkViewState();
}

class _ManajemenKkViewState extends State<ManajemenKkView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddEditDialog([KeluargaModel? item]) {
    final isEdit = item != null;

    final nameCtrl = TextEditingController(text: item?.namaKepalaKeluarga ?? '');
    final desaCtrl = TextEditingController(text: item?.desa ?? 'Japan');
    final alamatCtrl = TextEditingController(text: item?.alamat ?? 'RT 01 / RW 02');
    final dawisCtrl = TextEditingController(text: item?.dawis ?? '');
    final totalAnggotaCtrl = TextEditingController(text: item?.totalAnggota.toString() ?? '1');
    
    final lakiCtrl = TextEditingController(text: item?.jumlahLakiLaki.toString() ?? '0');
    final perempuanCtrl = TextEditingController(text: item?.jumlahPerempuan.toString() ?? '0');
    final balitaLakiCtrl = TextEditingController(text: item?.balitaLaki.toString() ?? '0');
    final balitaPerempuanCtrl = TextEditingController(text: item?.balitaPerempuan.toString() ?? '0');
    final lansiaCtrl = TextEditingController(text: item?.jumlahLansia.toString() ?? '0');
    final pusCtrl = TextEditingController(text: item?.jumlahPus.toString() ?? '0');
    final wusCtrl = TextEditingController(text: item?.jumlahWus.toString() ?? '0');
    final hamilCtrl = TextEditingController(text: item?.jumlahIbuHamil.toString() ?? '0');
    final ibuMenyusuiCtrl = TextEditingController(text: item?.jumlahIbuMenyusui.toString() ?? '0');
    
    final tunaHurufCtrl = TextEditingController(text: item?.tunaHuruf.toString() ?? '0');
    final tunaNetraCtrl = TextEditingController(text: item?.tunaNetra.toString() ?? '0');
    final tunaRunguCtrl = TextEditingController(text: item?.tunaRungu.toString() ?? '0');
    final berkebutuhanKhususCtrl = TextEditingController(text: item?.berkebutuhanKhusus.toString() ?? '0');

    String rumahSehat = item?.kriteriaRumah ?? 'Ya (Layak Huni)';
    String tempatSampah = (item?.tempatSampah ?? true) ? 'Ya' : 'Tidak';
    String spal = (item?.spal ?? true) ? 'Ya' : 'Tidak';
    String jambanKeluarga = (item?.jambanKeluarga ?? true) ? 'Ya' : 'Tidak';
    String stikerP4k = (item?.stikerP4k ?? true) ? 'Ya' : 'Tidak';

    String sumberAir = item?.sumberAir ?? 'PDAM';
    String makananPokok = item?.makananPokok ?? 'Beras';

    String up2k = (item?.up2k ?? true) ? 'Ya' : 'Tidak';
    String kegiatan2k = (item?.kegiatan2k ?? true) ? 'Ya' : 'Tidak';
    String ptp = (item?.ptp ?? true) ? 'Ya' : 'Tidak';
    String industriRt = (item?.industriRt ?? true) ? 'Ya' : 'Tidak';
    String kerjaBakti = (item?.kerjaBakti ?? true) ? 'Ya' : 'Tidak';

    final bantuanCtrl = TextEditingController(text: item?.namaBantuanHibah ?? '');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 640,
              constraints: const BoxConstraints(maxHeight: 760),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Blue Header Bar matching Canva Screenshot
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    color: const Color(0xFF1E3A8A), // Dark Navy Blue
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEdit ? 'Edit Kartu Keluarga' : 'Tambah Kartu Keluarga Baru',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(ctx),
                          child: const Icon(Icons.close, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ),

                  // Form Fields (Scrollable)
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. NAMA KEPALA KELUARGA *
                          _buildTextField(
                            label: "NAMA KEPALA KELUARGA *",
                            controller: nameCtrl,
                          ),
                          const SizedBox(height: 14),

                          // 2. NAMA DESA * & ALAMAT *
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: "NAMA DESA *",
                                  controller: desaCtrl,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _buildTextField(
                                  label: "ALAMAT *",
                                  controller: alamatCtrl,
                                  hint: "Contoh: RT 01 / RW 02",
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // 3. NAMA DAWIS * & JML ANGGOTA *
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: "NAMA DAWIS *",
                                  controller: dawisCtrl,
                                  hint: "Contoh: Dahlia 1",
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _buildTextField(
                                  label: "JML ANGGOTA *",
                                  controller: totalAnggotaCtrl,
                                  isNumber: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // 4. LAKI-LAKI & PEREMPUAN
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: "LAKI-LAKI",
                                  controller: lakiCtrl,
                                  isNumber: true,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _buildTextField(
                                  label: "PEREMPUAN",
                                  controller: perempuanCtrl,
                                  isNumber: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // 5. BALITA L & BALITA P
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: "BALITA L",
                                  controller: balitaLakiCtrl,
                                  isNumber: true,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _buildTextField(
                                  label: "BALITA P",
                                  controller: balitaPerempuanCtrl,
                                  isNumber: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // 6. LANSIA & PUS
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: "LANSIA",
                                  controller: lansiaCtrl,
                                  isNumber: true,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _buildTextField(
                                  label: "PUS",
                                  controller: pusCtrl,
                                  isNumber: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // 7. WUS & HAMIL
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: "WUS",
                                  controller: wusCtrl,
                                  isNumber: true,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _buildTextField(
                                  label: "HAMIL",
                                  controller: hamilCtrl,
                                  isNumber: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // 8. IBU MENYUSUI & TUNA HURUF
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: "IBU MENYUSUI",
                                  controller: ibuMenyusuiCtrl,
                                  isNumber: true,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _buildTextField(
                                  label: "TUNA HURUF",
                                  controller: tunaHurufCtrl,
                                  isNumber: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // 9. TUNA NETRA & TUNA RUNGU
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: "TUNA NETRA",
                                  controller: tunaNetraCtrl,
                                  isNumber: true,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _buildTextField(
                                  label: "TUNA RUNGU",
                                  controller: tunaRunguCtrl,
                                  isNumber: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // 10. BERKEBUTUHAN KHUSUS & RUMAH SEHAT
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: "BERKEBUTUHAN KHUSUS",
                                  controller: berkebutuhanKhususCtrl,
                                  isNumber: true,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _buildDropdownField(
                                  label: "RUMAH SEHAT",
                                  value: rumahSehat,
                                  items: const ["Ya (Layak Huni)", "Tidak (Tidak Layak Huni)"],
                                  onChanged: (val) => setDialogState(() => rumahSehat = val!),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // 11. TEMPAT SAMPAH & SPAL
                          Row(
                            children: [
                              Expanded(
                                child: _buildDropdownField(
                                  label: "TEMPAT SAMPAH",
                                  value: tempatSampah,
                                  items: const ["Ya", "Tidak"],
                                  onChanged: (val) => setDialogState(() => tempatSampah = val!),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _buildDropdownField(
                                  label: "SPAL",
                                  value: spal,
                                  items: const ["Ya", "Tidak"],
                                  onChanged: (val) => setDialogState(() => spal = val!),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // 12. JAMBAN KELUARGA & STIKER P4K
                          Row(
                            children: [
                              Expanded(
                                child: _buildDropdownField(
                                  label: "JAMBAN KELUARGA",
                                  value: jambanKeluarga,
                                  items: const ["Ya", "Tidak"],
                                  onChanged: (val) => setDialogState(() => jambanKeluarga = val!),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _buildDropdownField(
                                  label: "STIKER P4K",
                                  value: stikerP4k,
                                  items: const ["Ya", "Tidak"],
                                  onChanged: (val) => setDialogState(() => stikerP4k = val!),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // 13. SUMBER AIR & MAKANAN POKOK
                          Row(
                            children: [
                              Expanded(
                                child: _buildDropdownField(
                                  label: "SUMBER AIR",
                                  value: sumberAir,
                                  items: const ["PDAM", "Sumur", "Mata Air", "Lainnya"],
                                  onChanged: (val) => setDialogState(() => sumberAir = val!),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _buildDropdownField(
                                  label: "MAKANAN POKOK",
                                  value: makananPokok,
                                  items: const ["Beras", "Non Beras"],
                                  onChanged: (val) => setDialogState(() => makananPokok = val!),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // 14. UP2K & KEGIATAN 2K
                          Row(
                            children: [
                              Expanded(
                                child: _buildDropdownField(
                                  label: "UP2K",
                                  value: up2k,
                                  items: const ["Ya", "Tidak"],
                                  onChanged: (val) => setDialogState(() => up2k = val!),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _buildDropdownField(
                                  label: "KEGIATAN 2K",
                                  value: kegiatan2k,
                                  items: const ["Ya", "Tidak"],
                                  onChanged: (val) => setDialogState(() => kegiatan2k = val!),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // 15. PTP & INDUSTRI RT
                          Row(
                            children: [
                              Expanded(
                                child: _buildDropdownField(
                                  label: "PTP",
                                  value: ptp,
                                  items: const ["Ya", "Tidak"],
                                  onChanged: (val) => setDialogState(() => ptp = val!),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _buildDropdownField(
                                  label: "INDUSTRI RT",
                                  value: industriRt,
                                  items: const ["Ya", "Tidak"],
                                  onChanged: (val) => setDialogState(() => industriRt = val!),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // 16. KERJA BAKTI
                          Row(
                            children: [
                              Expanded(
                                child: _buildDropdownField(
                                  label: "KERJA BAKTI",
                                  value: kerjaBakti,
                                  items: const ["Ya", "Tidak"],
                                  onChanged: (val) => setDialogState(() => kerjaBakti = val!),
                                ),
                              ),
                              const SizedBox(width: 14),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // 17. NAMA BANTUAN HIBAH
                          _buildTextField(
                            label: "NAMA BANTUAN HIBAH",
                            controller: bantuanCtrl,
                            hint: "Ketik nama bantuan hibah jika ada...",
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Footer Buttons matching Canva Screenshot
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: AppTheme.borderColor)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            side: const BorderSide(color: AppTheme.borderColor),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text("Batal", style: TextStyle(color: AppTheme.textDark)),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            if (nameCtrl.text.trim().isEmpty) return;

                            final newItem = KeluargaModel(
                              id: isEdit ? item.id : DateTime.now().millisecondsSinceEpoch.toString(),
                              noKk: isEdit ? item.noKk : '331901${DateTime.now().millisecondsSinceEpoch}',
                              nikHead: isEdit ? item.nikHead : '331901${DateTime.now().millisecondsSinceEpoch}',
                              namaKepalaKeluarga: nameCtrl.text.trim(),
                              desa: desaCtrl.text.trim().isNotEmpty ? desaCtrl.text.trim() : 'Japan',
                              alamat: alamatCtrl.text.trim(),
                              rt: isEdit ? item.rt : '1',
                              rw: isEdit ? item.rw : '2',
                              dawis: dawisCtrl.text.trim().isNotEmpty ? dawisCtrl.text.trim() : 'Dahlia 1',
                              totalAnggota: int.tryParse(totalAnggotaCtrl.text) ?? 1,
                              jumlahLakiLaki: int.tryParse(lakiCtrl.text) ?? 0,
                              jumlahPerempuan: int.tryParse(perempuanCtrl.text) ?? 0,
                              balitaLaki: int.tryParse(balitaLakiCtrl.text) ?? 0,
                              balitaPerempuan: int.tryParse(balitaPerempuanCtrl.text) ?? 0,
                              jumlahLansia: int.tryParse(lansiaCtrl.text) ?? 0,
                              jumlahPus: int.tryParse(pusCtrl.text) ?? 0,
                              jumlahWus: int.tryParse(wusCtrl.text) ?? 0,
                              jumlahIbuHamil: int.tryParse(hamilCtrl.text) ?? 0,
                              jumlahIbuMenyusui: int.tryParse(ibuMenyusuiCtrl.text) ?? 0,
                              tunaHuruf: int.tryParse(tunaHurufCtrl.text) ?? 0,
                              tunaNetra: int.tryParse(tunaNetraCtrl.text) ?? 0,
                              tunaRungu: int.tryParse(tunaRunguCtrl.text) ?? 0,
                              berkebutuhanKhusus: int.tryParse(berkebutuhanKhususCtrl.text) ?? 0,
                              kriteriaRumah: rumahSehat,
                              tempatSampah: tempatSampah == 'Ya',
                              spal: spal == 'Ya',
                              jambanKeluarga: jambanKeluarga == 'Ya',
                              stikerP4k: stikerP4k == 'Ya',
                              sumberAir: sumberAir,
                              makananPokok: makananPokok,
                              up2k: up2k == 'Ya',
                              kegiatan2k: kegiatan2k == 'Ya',
                              ptp: ptp == 'Ya',
                              industriRt: industriRt == 'Ya',
                              kerjaBakti: kerjaBakti == 'Ya',
                              isPenerimaBantuan: bantuanCtrl.text.trim().isNotEmpty,
                              namaBantuanHibah: bantuanCtrl.text.trim(),
                              anggotaList: isEdit ? item.anggotaList : [],
                            );

                            if (isEdit) {
                              context.read<AppProvider>().updateKeluarga(newItem);
                            } else {
                              context.read<AppProvider>().addKeluarga(newItem);
                            }

                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF16A34A), // Solid Green
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text("Simpan", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF374151),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: const TextStyle(fontSize: 13, color: AppTheme.textDark),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.primaryBlue),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF374151),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: items.contains(value) ? value : items.first,
          style: const TextStyle(fontSize: 13, color: AppTheme.textDark),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final list = provider.filteredKeluargaList.where((k) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return k.namaKepalaKeluarga.toLowerCase().contains(q) ||
          k.dawis.toLowerCase().contains(q) ||
          k.alamat.toLowerCase().contains(q);
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Title & Anggota Keluarga Aktif Card
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Manajemen Data Keluarga - Desa Japan",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Filter & Search Bar Row
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        SizedBox(
                          width: 240,
                          height: 42,
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) => setState(() => _searchQuery = val),
                            decoration: InputDecoration(
                              hintText: "Cari kepala/anggota keluarga...",
                              hintStyle: const TextStyle(fontSize: 12, color: AppTheme.textMedium),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppTheme.borderColor)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppTheme.borderColor)),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppTheme.borderColor),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: provider.selectedDesa,
                              style: const TextStyle(fontSize: 13, color: AppTheme.textDark),
                              onChanged: (val) {
                                if (val != null) provider.setSelectedDesa(val);
                              },
                              items: ['Desa Japan', 'Desa Kudus'].map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppTheme.borderColor),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: provider.allDawisNames.contains(provider.selectedDawis) ? provider.selectedDawis : 'Semua Dawis',
                              style: const TextStyle(fontSize: 13, color: AppTheme.textDark),
                              onChanged: (val) {
                                if (val != null) provider.setSelectedDawis(val);
                              },
                              items: ['Semua Dawis', ...provider.allDawisNames].map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                            ),
                          ),
                        ),

                        ElevatedButton.icon(
                          onPressed: () => _showAddEditDialog(),
                          icon: const Icon(Icons.add_rounded, size: 16),
                          label: const Text("Tambah KK"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.softGreenText,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Anggota Keluarga Aktif Card (Top Right in Screenshot 1)
              Container(
                width: 320,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.borderColor),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.015), blurRadius: 8),
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
                            Icon(Icons.person_outline_rounded, size: 18, color: AppTheme.primaryBlue),
                            SizedBox(width: 6),
                            Text(
                              "Anggota Keluarga Aktif",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                            ),
                          ],
                        ),
                        Text("Pilih KK", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Klik nama Kepala Keluarga di tabel untuk melihat & menambah anggota keluarga.",
                      style: TextStyle(fontSize: 12, color: AppTheme.textMedium, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Detailed Data Table
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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(AppTheme.softBlueBg),
                headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark, fontSize: 12),
                dataTextStyle: const TextStyle(fontSize: 12, color: AppTheme.textDark),
                columns: const [
                  DataColumn(label: Text("No")),
                  DataColumn(label: Text("Kepala Keluarga")),
                  DataColumn(label: Text("Desa")),
                  DataColumn(label: Text("Alamat")),
                  DataColumn(label: Text("Dawis")),
                  DataColumn(label: Text("Anggota")),
                  DataColumn(label: Text("L")),
                  DataColumn(label: Text("P")),
                  DataColumn(label: Text("Balita L")),
                  DataColumn(label: Text("Balita P")),
                  DataColumn(label: Text("Lansia")),
                  DataColumn(label: Text("PUS")),
                  DataColumn(label: Text("WUS")),
                  DataColumn(label: Text("Hamil")),
                  DataColumn(label: Text("Menyusui")),
                  DataColumn(label: Text("T.Huruf")),
                  DataColumn(label: Text("T.Netra")),
                  DataColumn(label: Text("T.Rungu")),
                  DataColumn(label: Text("Khusus")),
                  DataColumn(label: Text("Rumah")),
                  DataColumn(label: Text("Air")),
                  DataColumn(label: Text("Pokok")),
                  DataColumn(label: Text("Bantuan")),
                  DataColumn(label: Text("Aksi")),
                ],
                rows: list.asMap().entries.map((entry) {
                  final idx = entry.key + 1;
                  final item = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(Text("$idx")),
                      DataCell(
                        Text(
                          item.namaKepalaKeluarga,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryBlueDark),
                        ),
                        onTap: () => provider.setSelectedKkForAnggota(item.namaKepalaKeluarga),
                      ),
                      DataCell(Text(item.desa)),
                      DataCell(Text(item.alamat)),
                      DataCell(Text(item.dawis)),
                      DataCell(Text("${item.totalAnggota}")),
                      DataCell(Text("${item.jumlahLakiLaki}")),
                      DataCell(Text("${item.jumlahPerempuan}")),
                      DataCell(Text("${item.balitaLaki}")),
                      DataCell(Text("${item.balitaPerempuan}")),
                      DataCell(Text("${item.jumlahLansia}")),
                      DataCell(Text("${item.jumlahPus}")),
                      DataCell(Text("${item.jumlahWus}")),
                      DataCell(Text("${item.jumlahIbuHamil}")),
                      DataCell(Text("${item.jumlahIbuMenyusui}")),
                      DataCell(Text("${item.tunaHuruf}")),
                      DataCell(Text("${item.tunaNetra}")),
                      DataCell(Text("${item.tunaRungu}")),
                      DataCell(Text("${item.berkebutuhanKhusus}")),
                      DataCell(Text(item.kriteriaRumah.contains('Ya') ? "Sehat" : "Tidak", style: TextStyle(color: item.kriteriaRumah.contains('Ya') ? AppTheme.softGreenText : AppTheme.dangerRed, fontWeight: FontWeight.bold))),
                      DataCell(Text(item.sumberAir)),
                      DataCell(Text(item.makananPokok)),
                      DataCell(Text(item.namaBantuanHibah.isNotEmpty ? item.namaBantuanHibah : "-")),
                      DataCell(
                        Row(
                          children: [
                            InkWell(
                              onTap: () => provider.setSelectedKkForAnggota(item.namaKepalaKeluarga),
                              child: const Text("Tambah Anggota", style: TextStyle(color: AppTheme.softGreenText, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () => _showAddEditDialog(item),
                              child: const Text("Edit", style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () => provider.deleteKeluarga(item.id),
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
