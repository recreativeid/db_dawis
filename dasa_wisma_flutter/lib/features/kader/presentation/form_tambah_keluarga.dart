import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../warga/providers/warga_provider.dart';
import '../../kades/providers/dashboard_provider.dart';

class FormTambahKeluarga extends StatefulWidget {
  const FormTambahKeluarga({super.key});

  @override
  State<FormTambahKeluarga> createState() => _FormTambahKeluargaState();
}

class _FormTambahKeluargaState extends State<FormTambahKeluarga> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers untuk KK
  final _noKkController = TextEditingController();
  String _kriteriaRumah = 'Sehat Layak Huni';
  
  // Controllers untuk Kepala Keluarga
  final _nikController = TextEditingController();
  final _namaController = TextEditingController();
  String _jenisKelamin = 'L';
  DateTime? _tanggalLahir;

  @override
  void dispose() {
    _noKkController.dispose();
    _nikController.dispose();
    _namaController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryBlue,
              onPrimary: Colors.white,
              onSurface: AppTheme.textDark,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppTheme.primaryBlue),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _tanggalLahir) {
      setState(() {
        _tanggalLahir = picked;
      });
    }
  }

  void _simpanData() async {
    if (_formKey.currentState!.validate() && _tanggalLahir != null) {
      final data = {
        'no_kk': _noKkController.text,
        'dawis_id': 1, // Hardcode sementara, aslinya ambil dari dropdown dawis
        'kriteria_rumah': _kriteriaRumah,
        'nik': _nikController.text,
        'nama_lengkap': _namaController.text,
        'jenis_kelamin': _jenisKelamin,
        'tanggal_lahir': "${_tanggalLahir!.year}-${_tanggalLahir!.month.toString().padLeft(2, '0')}-${_tanggalLahir!.day.toString().padLeft(2, '0')}"
      };

      final provider = context.read<WargaProvider>();
      final success = await provider.tambahKeluarga(data);

      if (!mounted) return;

      if (success) {
        // Refresh statistik Kades agar realtime terupdate
        context.read<DashboardProvider>().fetchStatistik();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Berhasil menambah Keluarga baru!'), 
            backgroundColor: AppTheme.successGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal: ${provider.error}'), 
            backgroundColor: AppTheme.dangerRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } else if (_tanggalLahir == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Tanggal lahir harus diisi!'), 
          backgroundColor: AppTheme.dangerRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text(
          "Input Data Keluarga",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppTheme.textDark),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Seksi 1: Data Kartu Keluarga
              const Text(
                "Data Kartu Keluarga (KK)", 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark)
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
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
                child: Column(
                  children: [
                    TextFormField(
                      controller: _noKkController,
                      decoration: const InputDecoration(
                        labelText: "Nomor KK",
                        hintText: "Masukkan 16 digit nomor KK",
                        prefixIcon: Icon(Icons.assignment_rounded, color: AppTheme.primaryBlue),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? "Nomor KK tidak boleh kosong" : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _kriteriaRumah,
                      decoration: const InputDecoration(
                        labelText: "Kriteria Rumah",
                        prefixIcon: Icon(Icons.home_work_rounded, color: AppTheme.primaryBlue),
                      ),
                      dropdownColor: Colors.white,
                      items: ['Sehat Layak Huni', 'Tidak Sehat Layak Huni'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) => setState(() => _kriteriaRumah = newValue!),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 28),
              
              // Seksi 2: Data Kepala Keluarga
              const Text(
                "Data Kepala Keluarga", 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark)
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
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
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nikController,
                      decoration: const InputDecoration(
                        labelText: "NIK",
                        hintText: "Masukkan 16 digit NIK Kepala Keluarga",
                        prefixIcon: Icon(Icons.badge_rounded, color: AppTheme.primaryBlue),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? "NIK tidak boleh kosong" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _namaController,
                      decoration: const InputDecoration(
                        labelText: "Nama Lengkap",
                        hintText: "Nama sesuai KTP",
                        prefixIcon: Icon(Icons.person_rounded, color: AppTheme.primaryBlue),
                      ),
                      validator: (value) => value!.isEmpty ? "Nama lengkap tidak boleh kosong" : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _jenisKelamin,
                      decoration: const InputDecoration(
                        labelText: "Jenis Kelamin",
                        prefixIcon: Icon(Icons.wc_rounded, color: AppTheme.primaryBlue),
                      ),
                      dropdownColor: Colors.white,
                      items: const [
                        DropdownMenuItem(value: 'L', child: Text("Laki-laki")),
                        DropdownMenuItem(value: 'P', child: Text("Perempuan")),
                      ],
                      onChanged: (newValue) => setState(() => _jenisKelamin = newValue!),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () => _selectDate(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today_rounded, color: AppTheme.primaryBlue, size: 20),
                                const SizedBox(width: 12),
                                Text(
                                  _tanggalLahir == null 
                                      ? 'Pilih Tanggal Lahir' 
                                      : "${_tanggalLahir!.day}/${_tanggalLahir!.month}/${_tanggalLahir!.year}",
                                  style: TextStyle(
                                    color: _tanggalLahir == null ? AppTheme.textLight : AppTheme.textDark,
                                    fontWeight: _tanggalLahir == null ? FontWeight.normal : FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(Icons.arrow_drop_down_rounded, color: AppTheme.textMedium),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 36),
              
              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                child: context.watch<WargaProvider>().isLoading 
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue, 
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _simpanData,
                        child: const Text("SIMPAN DATA KELUARGA", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                      ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
