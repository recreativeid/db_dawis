class UserModel {
  final String id;
  final String username; // NIK for Warga, Username for Kader/Kades
  final String? email;
  final String password;
  final String namaLengkap;
  final String role; // "warga", "kader", "kades"
  final String? nik;

  UserModel({
    required this.id,
    required this.username,
    this.email,
    required this.password,
    required this.namaLengkap,
    required this.role,
    this.nik,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? '',
      email: json['email'],
      password: json['password'] ?? '',
      namaLengkap: json['nama_lengkap'] ?? '',
      role: json['role'] ?? 'warga',
      nik: json['nik'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'nama_lengkap': namaLengkap,
      'role': role,
      'nik': nik,
    };
  }
}

class AnggotaKeluargaModel {
  final String nik;
  final String nama;
  final String hubungan;
  final String jenisKelamin;
  final int usia;

  AnggotaKeluargaModel({
    required this.nik,
    required this.nama,
    required this.hubungan,
    required this.jenisKelamin,
    required this.usia,
  });

  factory AnggotaKeluargaModel.fromJson(Map<String, dynamic> json) {
    return AnggotaKeluargaModel(
      nik: json['nik'] ?? '',
      nama: json['nama'] ?? '',
      hubungan: json['hubungan'] ?? 'Anggota',
      jenisKelamin: json['jenis_kelamin'] ?? 'Laki-laki',
      usia: json['usia'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nik': nik,
      'nama': nama,
      'hubungan': hubungan,
      'jenis_kelamin': jenisKelamin,
      'usia': usia,
    };
  }
}

class KeluargaModel {
  final String id;
  final String noKk;
  final String nikHead;
  final String namaKepalaKeluarga;
  final String desa;
  final String alamat;
  final String rt;
  final String rw;
  final String dawis;
  
  // Demografi
  final int totalAnggota;
  final int jumlahLakiLaki;
  final int jumlahPerempuan;
  final int balitaLaki;
  final int balitaPerempuan;
  final int jumlahLansia;
  final int jumlahPus;
  final int jumlahWus;
  final int jumlahIbuHamil;
  final int jumlahIbuMenyusui;
  
  // 3 Buta & Disabilitas
  final int tunaHuruf;
  final int tunaNetra;
  final int tunaRungu;
  final int berkebutuhanKhusus;

  // Kriteria & Fasilitas Rumah
  final String kriteriaRumah; // "Ya (Layak Huni)" / "Tidak (Tidak Layak Huni)"
  final bool tempatSampah;
  final bool spal;
  final bool jambanKeluarga;
  final bool stikerP4k;

  // Sumber Air & Makanan Pokok
  final String sumberAir;    // "PDAM", "Sumur", "Mata Air", "Lainnya"
  final String makananPokok; // "Beras", "Non Beras"

  // Partisipasi Kegiatan (Booleans)
  final bool up2k;
  final bool kegiatan2k;
  final bool ptp;
  final bool industriRt;
  final bool kerjaBakti;
  final String partisipasiKegiatan; // Backward compatibility string

  // Bantuan Hibah
  final bool isPenerimaBantuan;
  final String namaBantuanHibah; // e.g. "PKH", "PJK", etc.

  // Anggota Keluarga List
  final List<AnggotaKeluargaModel> anggotaList;

  KeluargaModel({
    required this.id,
    this.noKk = '3319012345670001',
    this.nikHead = '3319011205800002',
    required this.namaKepalaKeluarga,
    this.desa = 'Japan',
    this.alamat = 'RT 01 / RW 02',
    this.rt = '1',
    this.rw = '2',
    required this.dawis,
    this.totalAnggota = 1,
    this.jumlahLakiLaki = 0,
    this.jumlahPerempuan = 0,
    this.balitaLaki = 0,
    this.balitaPerempuan = 0,
    this.jumlahLansia = 0,
    this.jumlahPus = 0,
    this.jumlahWus = 0,
    this.jumlahIbuHamil = 0,
    this.jumlahIbuMenyusui = 0,
    this.tunaHuruf = 0,
    this.tunaNetra = 0,
    this.tunaRungu = 0,
    this.berkebutuhanKhusus = 0,
    this.kriteriaRumah = 'Ya (Layak Huni)',
    this.tempatSampah = true,
    this.spal = true,
    this.jambanKeluarga = true,
    this.stikerP4k = true,
    this.sumberAir = 'PDAM',
    this.makananPokok = 'Beras',
    this.up2k = true,
    this.kegiatan2k = true,
    this.ptp = true,
    this.industriRt = true,
    this.kerjaBakti = true,
    this.partisipasiKegiatan = 'UP2K',
    this.isPenerimaBantuan = true,
    this.namaBantuanHibah = 'PJK',
    this.anggotaList = const [],
  });

  int get totalBalita => balitaLaki + balitaPerempuan;
  String get jenisBantuan => namaBantuanHibah;

  int get skorRLH {
    int skor = 0;
    final air = sumberAir.toLowerCase();
    if (air.contains('pdam')) {
      skor += 25;
    } else if (air.contains('sumur') || air.contains('mata air')) {
      skor += 20;
    }
    if (jambanKeluarga) skor += 25;
    if (spal) skor += 20;
    if (tempatSampah) skor += 15;
    skor += 15; // listrik
    return skor;
  }

  String get statusKelayakanRLH {
    final s = skorRLH;
    if (s >= 75) return 'Rumah Layak Huni (RLH)';
    if (s >= 50) return 'RTLH Ringan / Sedang';
    return 'RTLH Berat';
  }

  factory KeluargaModel.fromJson(Map<String, dynamic> json) {
    return KeluargaModel(
      id: json['id']?.toString() ?? '',
      noKk: json['no_kk'] ?? '3319012345670001',
      nikHead: json['nik_head'] ?? '3319011205800002',
      namaKepalaKeluarga: json['nama_kepala_keluarga'] ?? json['nama'] ?? '',
      desa: json['desa'] ?? 'Japan',
      alamat: json['alamat'] ?? 'RT 01 / RW 02',
      rt: json['rt'] ?? '1',
      rw: json['rw'] ?? '2',
      dawis: json['dawis'] ?? 'Dahlia 1',
      totalAnggota: json['total_anggota'] ?? 1,
      jumlahLakiLaki: json['jumlah_laki'] ?? 0,
      jumlahPerempuan: json['jumlah_perempuan'] ?? 0,
      balitaLaki: json['balita_laki'] ?? 0,
      balitaPerempuan: json['balita_perempuan'] ?? 0,
      jumlahLansia: json['jumlah_lansia'] ?? 0,
      jumlahPus: json['jumlah_pus'] ?? 0,
      jumlahWus: json['jumlah_wus'] ?? 0,
      jumlahIbuHamil: json['jumlah_ibu_hamil'] ?? 0,
      jumlahIbuMenyusui: json['jumlah_ibu_menyusui'] ?? 0,
      tunaHuruf: json['tuna_huruf'] ?? 0,
      tunaNetra: json['tuna_netra'] ?? 0,
      tunaRungu: json['tuna_rungu'] ?? 0,
      berkebutuhanKhusus: json['berkebutuhan_khusus'] ?? 0,
      kriteriaRumah: json['kriteria_rumah'] ?? 'Ya (Layak Huni)',
      tempatSampah: json['tempat_sampah'] ?? true,
      spal: json['spal'] ?? true,
      jambanKeluarga: json['jamban_keluarga'] ?? true,
      stikerP4k: json['stiker_p4k'] ?? true,
      sumberAir: json['sumber_air'] ?? 'PDAM',
      makananPokok: json['makanan_pokok'] ?? 'Beras',
      up2k: json['up2k'] ?? true,
      kegiatan2k: json['kegiatan_2k'] ?? true,
      ptp: json['ptp'] ?? true,
      industriRt: json['industri_rt'] ?? true,
      kerjaBakti: json['kerja_bakti'] ?? true,
      partisipasiKegiatan: json['partisipasi_kegiatan'] ?? 'UP2K',
      isPenerimaBantuan: json['is_penerima_bantuan'] ?? true,
      namaBantuanHibah: json['nama_bantuan_hibah'] ?? 'PJK',
      anggotaList: (json['anggota_list'] as List?)?.map((a) => AnggotaKeluargaModel.fromJson(a)).toList() ?? [],
    );
  }
}

class DawisModel {
  final String nama;
  final String rt;
  final String rw;

  DawisModel({
    required this.nama,
    required this.rt,
    required this.rw,
  });

  factory DawisModel.fromJson(Map<String, dynamic> json) {
    return DawisModel(
      nama: json['nama'] ?? '',
      rt: json['rt'] ?? '1',
      rw: json['rw'] ?? '1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'rt': rt,
      'rw': rw,
    };
  }
}


