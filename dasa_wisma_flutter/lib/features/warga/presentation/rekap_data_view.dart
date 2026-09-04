import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/app_provider.dart';

class RekapDataView extends StatelessWidget {
  const RekapDataView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final filteredList = provider.filteredKeluargaList;

    // Get unique list of Dawis for dropdown filter
    final dawisSet = <String>{'Semua Dawis', ...provider.allDawisNames};
    final dawisList = dawisSet.toList()..sort();
    final currentDawis = dawisList.contains(provider.selectedDawis) ? provider.selectedDawis : 'Semua Dawis';


    return SingleChildScrollView(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Title & Dawis Filter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Rekap Data - Desa Japan",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Ringkasan dan Rekapitulasi Data Kependudukan Dasa Wisma",
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textDark.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: currentDawis,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.primaryBlue),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textDark),
                    onChanged: (val) {
                      if (val != null) {
                        provider.setSelectedDawis(val);
                      }
                    },
                    items: dawisList.map((dawis) {
                      return DropdownMenuItem<String>(
                        value: dawis,
                        child: Text("Filter: $dawis"),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Section 1: Data Kependudukan
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
                const Text(
                  "Data Kependudukan",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                
                LayoutBuilder(
                  builder: (context, constraints) {
                    int cols = constraints.maxWidth > 800 ? 5 : (constraints.maxWidth > 500 ? 3 : 2);
                    return GridView.count(
                      crossAxisCount: cols,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.1,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildMetricTile("Total KK", provider.totalKK.toString(), AppTheme.softBlueBg, AppTheme.softBlueText),
                        _buildMetricTile("Total Warga", provider.totalWarga.toString(), AppTheme.softBlueBg, AppTheme.softBlueText),
                        _buildMetricTile("Laki-laki", provider.totalLaki.toString(), AppTheme.softBlueBg, AppTheme.softBlueText),
                        _buildMetricTile("Perempuan", provider.totalPerempuan.toString(), AppTheme.softBlueBg, AppTheme.softBlueText),
                        _buildMetricTile("Balita", provider.totalBalita.toString(), AppTheme.softGreenBg, AppTheme.softGreenText),
                        _buildMetricTile("Lansia", provider.totalLansia.toString(), AppTheme.softYellowBg, AppTheme.softYellowText),
                        _buildMetricTile("PUS", provider.totalPus.toString(), AppTheme.softPinkBg, AppTheme.softPinkText),
                        _buildMetricTile("WUS", provider.totalWus.toString(), AppTheme.softPinkBg, AppTheme.softPinkText),
                        _buildMetricTile("Ibu Hamil", provider.totalIbuHamil.toString(), AppTheme.softPinkBg, AppTheme.softPinkText),
                        _buildMetricTile("Ibu Menyusui", provider.totalIbuMenyusui.toString(), AppTheme.softPinkBg, AppTheme.softPinkText),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Section 2: 3 Buta & Berkebutuhan Khusus
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
                const Text(
                  "Penyandang Disabilitas & Berkebutuhan Khusus",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                
                LayoutBuilder(
                  builder: (context, constraints) {
                    int cols = constraints.maxWidth > 800 ? 4 : (constraints.maxWidth > 500 ? 2 : 1);
                    return GridView.count(
                      crossAxisCount: cols,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildMetricTile("Tuna Huruf", provider.totalTunaHuruf.toString(), const Color(0xFFF1F5F9), AppTheme.textDark),
                        _buildMetricTile("Tuna Netra", provider.totalTunaNetra.toString(), const Color(0xFFF1F5F9), AppTheme.textDark),
                        _buildMetricTile("Tuna Rungu", provider.totalTunaRungu.toString(), const Color(0xFFF1F5F9), AppTheme.textDark),
                        _buildMetricTile("Berkebutuhan Khusus", provider.totalBerkebutuhanKhusus.toString(), const Color(0xFFF1F5F9), AppTheme.textDark),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Section 3: Fasilitas & Kriteria Rumah
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
                const Text(
                  "Fasilitas & Kriteria Rumah",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                
                LayoutBuilder(
                  builder: (context, constraints) {
                    int cols = constraints.maxWidth > 800 ? 5 : (constraints.maxWidth > 500 ? 3 : 1);
                    return GridView.count(
                      crossAxisCount: cols,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildMetricTile("Jamban Sehat", provider.totalJamban.toString(), AppTheme.softBlueBg, AppTheme.softBlueText),
                        _buildMetricTile("Tempat Sampah", provider.totalSampah.toString(), AppTheme.softBlueBg, AppTheme.softBlueText),
                        _buildMetricTile("SPAL", provider.totalSpal.toString(), AppTheme.softBlueBg, AppTheme.softBlueText),
                        _buildMetricTile("Air Minum (PDAM)", provider.totalPdam.toString(), AppTheme.softBlueBg, AppTheme.softBlueText),
                        _buildMetricTile("Listrik", provider.totalListrik.toString(), AppTheme.softBlueBg, AppTheme.softBlueText),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Section 4: Tabel Detail Rekapitulasi Data Kartu Keluarga
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
                  children: [
                    const Text(
                      "Tabel Rekapitulasi Data Kartu Keluarga (KK)",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    Text(
                      "Total: ${filteredList.length} KK",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                filteredList.isEmpty
                    ? Container(
                        padding: const EdgeInsets.all(32),
                        alignment: Alignment.center,
                        child: const Text("Belum ada data Kartu Keluarga untuk dawis ini."),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(AppTheme.softBlueBg),
                            headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark, fontSize: 12),
                            dataTextStyle: const TextStyle(fontSize: 12, color: AppTheme.textDark),
                            columns: const [
                              DataColumn(label: Text("No")),
                              DataColumn(label: Text("Kepala Keluarga")),
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
                              DataColumn(label: Text("Bantuan")),
                            ],
                            rows: filteredList.asMap().entries.map((entry) {
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
                                  ),
                                  DataCell(Text(item.alamat)),
                                  DataCell(Text(item.dawis)),
                                  DataCell(Text("${item.totalAnggota}")),
                                  DataCell(Text("${item.jumlahLakiLaki}")),
                                  DataCell(Text("${item.jumlahPerempuan}")),
                                  DataCell(Text("${item.balitaLaki}")),
                                  DataCell(Text("${item.balitaPerempuan}")),
                                  DataCell(Text("${item.jumlahLansia}")),
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: item.jumlahPus > 0 ? AppTheme.softPinkBg : Colors.transparent,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        "${item.jumlahPus}",
                                        style: TextStyle(
                                          fontWeight: item.jumlahPus > 0 ? FontWeight.bold : FontWeight.normal,
                                          color: item.jumlahPus > 0 ? AppTheme.softPinkText : AppTheme.textDark,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: item.jumlahWus > 0 ? AppTheme.softPinkBg : Colors.transparent,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        "${item.jumlahWus}",
                                        style: TextStyle(
                                          fontWeight: item.jumlahWus > 0 ? FontWeight.bold : FontWeight.normal,
                                          color: item.jumlahWus > 0 ? AppTheme.softPinkText : AppTheme.textDark,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: item.jumlahIbuHamil > 0 ? AppTheme.softPinkBg : Colors.transparent,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        "${item.jumlahIbuHamil}",
                                        style: TextStyle(
                                          fontWeight: item.jumlahIbuHamil > 0 ? FontWeight.bold : FontWeight.normal,
                                          color: item.jumlahIbuHamil > 0 ? AppTheme.softPinkText : AppTheme.textDark,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: item.jumlahIbuMenyusui > 0 ? AppTheme.softPinkBg : Colors.transparent,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        "${item.jumlahIbuMenyusui}",
                                        style: TextStyle(
                                          fontWeight: item.jumlahIbuMenyusui > 0 ? FontWeight.bold : FontWeight.normal,
                                          color: item.jumlahIbuMenyusui > 0 ? AppTheme.softPinkText : AppTheme.textDark,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(Text("${item.tunaHuruf}")),
                                  DataCell(Text("${item.tunaNetra}")),
                                  DataCell(Text("${item.tunaRungu}")),
                                  DataCell(Text("${item.berkebutuhanKhusus}")),
                                  DataCell(
                                    Text(
                                      item.kriteriaRumah.contains('Ya') ? "Sehat" : "Tidak",
                                      style: TextStyle(
                                        color: item.kriteriaRumah.contains('Ya') ? AppTheme.softGreenText : AppTheme.dangerRed,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataCell(Text(item.sumberAir)),
                                  DataCell(Text(item.namaBantuanHibah.isNotEmpty ? item.namaBantuanHibah : "-")),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(String title, String value, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
