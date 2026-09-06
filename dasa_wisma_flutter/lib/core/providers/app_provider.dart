import 'package:flutter/material.dart';
import '../models/dasa_wisma_model.dart';

enum UserRole { warga, kader, kades }

class BantuanItemModel {
  final String id;
  final String namaKepalaKeluarga;
  final String namaBantuan;
  final String status;
  final String diajukanOleh;
  final String tanggal;

  BantuanItemModel({
    required this.id,
    required this.namaKepalaKeluarga,
    required this.namaBantuan,
    this.status = 'Menunggu Persetujuan',
    this.diajukanOleh = 'Kader Siti Aminah',
    this.tanggal = '06/09/2026',
  });
}

class AppProvider with ChangeNotifier {
  UserRole _activeRole = UserRole.warga;
  String _activeMenu = 'dashboard';
  bool _isSidebarCollapsed = false;
  
  String _selectedDesa = 'Desa Japan';
  String _selectedDawis = 'Semua Dawis';
  String _selectedKkIdForAnggota = '1';

  UserModel? _currentUser;

  // Registered User Accounts (For Email/NIK login, user management by Kader & Kades)
  final List<UserModel> _users = [
    UserModel(
      id: '1',
      username: '3319011205800002',
      email: 'budi.santoso@japan.desa.id',
      password: '123',
      namaLengkap: 'Budi Santoso',
      role: 'warga',
      nik: '3319011205800002',
    ),
    UserModel(
      id: '2',
      username: 'kader',
      email: 'kader@japan.desa.id',
      password: '123',
      namaLengkap: 'Siti Aminah (Kader)',
      role: 'kader',
    ),
    UserModel(
      id: '3',
      username: 'kades',
      email: 'kades@japan.desa.id',
      password: '123',
      namaLengkap: 'Bapak Kepala Desa Japan',
      role: 'kades',
    ),
  ];

  // Master list of Bantuan Hibah tags/names defined by Kepala Desa
  List<String> _masterBantuanHibah = ['PKH', 'BPNT', 'BLT Dana Desa', 'PJK'];
  List<BantuanItemModel> _bantuanRecordList = [
    BantuanItemModel(id: '1', namaKepalaKeluarga: 'Budi Santoso', namaBantuan: 'PKH', status: 'Disetujui', diajukanOleh: 'Kader Siti Aminah', tanggal: '01/09/2026'),
    BantuanItemModel(id: '2', namaKepalaKeluarga: 'Slamet Riyadi', namaBantuan: 'BLT', status: 'Menunggu Persetujuan', diajukanOleh: 'Kader Siti Aminah', tanggal: '05/09/2026'),
    BantuanItemModel(id: '3', namaKepalaKeluarga: 'Arjun Naja', namaBantuan: 'BPNT', status: 'Menunggu Persetujuan', diajukanOleh: 'Kader Siti Aminah', tanggal: '06/09/2026'),
    BantuanItemModel(id: '4', namaKepalaKeluarga: 'Budi Santoso', namaBantuan: 'PJK', status: 'Disetujui', diajukanOleh: 'Kepala Desa', tanggal: '02/09/2026'),
  ];

  // Master list of Dawis (Dasa Wisma) with RT & RW
  final List<DawisModel> _masterDawisList = [
    DawisModel(nama: 'Dahlia 1', rt: '1', rw: '4'),
    DawisModel(nama: 'Dahlia 2', rt: '2', rw: '4'),
    DawisModel(nama: 'Dahlia 9', rt: '3', rw: '4'),
  ];


  // Initial Seed Data
  final List<KeluargaModel> _keluargaList = [
    KeluargaModel(
      id: '1',
      noKk: '3319012345670001',
      nikHead: '3319011205800002',
      namaKepalaKeluarga: 'Budi Santoso',
      desa: 'Japan',
      alamat: 'RT 01 / RW 04',
      rt: '1',
      rw: '4',
      dawis: 'Dahlia 1',
      totalAnggota: 3,
      jumlahLakiLaki: 1,
      jumlahPerempuan: 2,
      balitaLaki: 0,
      balitaPerempuan: 1,
      jumlahLansia: 0,
      jumlahPus: 1,
      jumlahWus: 1,
      jumlahIbuHamil: 1,
      jumlahIbuMenyusui: 1,
      tunaHuruf: 1,
      tunaNetra: 1,
      tunaRungu: 0,
      berkebutuhanKhusus: 0,
      kriteriaRumah: 'Ya (Layak Huni)',
      tempatSampah: true,
      spal: true,
      jambanKeluarga: true,
      stikerP4k: true,
      sumberAir: 'PDAM',
      makananPokok: 'Beras',
      up2k: true,
      kegiatan2k: true,
      ptp: true,
      industriRt: true,
      kerjaBakti: true,
      partisipasiKegiatan: 'UP2K',
      isPenerimaBantuan: true,
      namaBantuanHibah: 'PJK',
      anggotaList: [
        AnggotaKeluargaModel(
          nik: '3319011205800002',
          nama: 'Budi Santoso',
          hubungan: 'Kepala Keluarga',
          jenisKelamin: 'Laki-laki',
          usia: 45,
        ),
        AnggotaKeluargaModel(
          nik: '3319015506820003',
          nama: 'Siti Aminah',
          hubungan: 'Istri',
          jenisKelamin: 'Perempuan',
          usia: 40,
        ),
        AnggotaKeluargaModel(
          nik: '3319016003210001',
          nama: 'Rina Santoso',
          hubungan: 'Anak',
          jenisKelamin: 'Perempuan',
          usia: 3,
        ),
      ],
    ),
    KeluargaModel(
      id: '2',
      noKk: '3319012345670002',
      nikHead: '3319011508850005',
      namaKepalaKeluarga: 'Slamet Riyadi',
      desa: 'Japan',
      alamat: 'RT 02 / RW 04',
      rt: '2',
      rw: '4',
      dawis: 'Dahlia 2',
      totalAnggota: 4,
      jumlahLakiLaki: 3,
      jumlahPerempuan: 1,
      balitaLaki: 1,
      balitaPerempuan: 0,
      jumlahLansia: 1,
      jumlahPus: 1,
      jumlahWus: 1,
      jumlahIbuHamil: 0,
      jumlahIbuMenyusui: 1,
      tunaHuruf: 0,
      tunaNetra: 0,
      tunaRungu: 1,
      berkebutuhanKhusus: 1,
      kriteriaRumah: 'Ya (Layak Huni)',
      tempatSampah: true,
      spal: true,
      jambanKeluarga: true,
      stikerP4k: true,
      sumberAir: 'PDAM',
      makananPokok: 'Beras',
      up2k: true,
      kegiatan2k: true,
      ptp: true,
      industriRt: false,
      kerjaBakti: true,
      partisipasiKegiatan: 'UP2K',
      isPenerimaBantuan: true,
      namaBantuanHibah: 'PJK',
      anggotaList: [
        AnggotaKeluargaModel(
          nik: '3319011508850005',
          nama: 'Slamet Riyadi',
          hubungan: 'Kepala Keluarga',
          jenisKelamin: 'Laki-laki',
          usia: 50,
        ),
        AnggotaKeluargaModel(
          nik: '3319015809860002',
          nama: 'Sri Wahyuni',
          hubungan: 'Istri',
          jenisKelamin: 'Perempuan',
          usia: 42,
        ),
        AnggotaKeluargaModel(
          nik: '3319010107540001',
          nama: 'Mbah Joyo',
          hubungan: 'Orang Tua',
          jenisKelamin: 'Laki-laki',
          usia: 70,
        ),
        AnggotaKeluargaModel(
          nik: '3319011204220003',
          nama: 'Doni Riyadi',
          hubungan: 'Anak',
          jenisKelamin: 'Laki-laki',
          usia: 4,
        ),
      ],
    ),
  ];

  UserRole get activeRole => _activeRole;
  String get activeMenu => _activeMenu;
  bool get isSidebarCollapsed => _isSidebarCollapsed;
  String get selectedDesa => _selectedDesa;
  String get selectedDawis => _selectedDawis;
  String get selectedKkIdForAnggota => _selectedKkIdForAnggota;
  List<String> get masterBantuanHibah => _masterBantuanHibah;
  List<String> get bantuanTags => _masterBantuanHibah;
  List<BantuanItemModel> get bantuanList => _bantuanRecordList;
  List<KeluargaModel> get keluargaList => _keluargaList;
  List<UserModel> get userList => _users;
  UserModel? get currentUser => _currentUser;
  List<DawisModel> get masterDawisList => _masterDawisList;

  DawisModel? findDawis(String nama) {
    try {
      return _masterDawisList.firstWhere((d) => d.nama.trim().toLowerCase() == nama.trim().toLowerCase());
    } catch (_) {
      return null;
    }
  }

  void addOrUpdateDawis({required String nama, required String rt, required String rw}) {
    final cleanNama = nama.trim();
    if (cleanNama.isEmpty) return;
    int idx = _masterDawisList.indexWhere((d) => d.nama.trim().toLowerCase() == cleanNama.toLowerCase());
    if (idx != -1) {
      _masterDawisList[idx] = DawisModel(nama: cleanNama, rt: rt, rw: rw);
    } else {
      _masterDawisList.add(DawisModel(nama: cleanNama, rt: rt, rw: rw));
    }
    notifyListeners();
  }

  List<String> get allDawisNames {
    final names = <String>{};
    for (var d in _masterDawisList) {
      if (d.nama.trim().isNotEmpty) names.add(d.nama.trim());
    }
    for (var k in _keluargaList) {
      if (k.dawis.trim().isNotEmpty) names.add(k.dawis.trim());
    }
    return names.toList()..sort();
  }


  void selectRole(UserRole role) {
    _activeRole = role;
    _activeMenu = 'dashboard';
    notifyListeners();
  }

  void setActiveMenu(String menuKey) {
    _activeMenu = menuKey;
    notifyListeners();
  }

  void toggleSidebar() {
    _isSidebarCollapsed = !_isSidebarCollapsed;
    notifyListeners();
  }

  void setSelectedDesa(String value) {
    _selectedDesa = value;
    notifyListeners();
  }

  void setSelectedDawis(String value) {
    _selectedDawis = value;
    notifyListeners();
  }

  void setSelectedKkIdForAnggota(String id) {
    _selectedKkIdForAnggota = id;
    notifyListeners();
  }

  void setSelectedKkForAnggota(String name) {
    _selectedKkIdForAnggota = name;
    notifyListeners();
  }

  // --- USER AUTHENTICATION & MANAGEMENT METHODS ---

  bool registerWargaPassword({
    required String nik,
    required String namaLengkap,
    required String password,
    String? email,
  }) {
    int existingIdx = _users.indexWhere((u) => u.username == nik || u.nik == nik || (email != null && u.email == email));
    if (existingIdx != -1) {
      _users[existingIdx] = UserModel(
        id: _users[existingIdx].id,
        username: nik,
        email: email ?? _users[existingIdx].email,
        password: password,
        namaLengkap: namaLengkap.isNotEmpty ? namaLengkap : _users[existingIdx].namaLengkap,
        role: 'warga',
        nik: nik,
      );
    } else {
      _users.add(UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        username: nik,
        email: email,
        password: password,
        namaLengkap: namaLengkap,
        role: 'warga',
        nik: nik,
      ));
    }
    notifyListeners();
    return true;
  }

  bool createAkunWarga({
    required String email,
    required String password,
    required String namaLengkap,
    String? nik,
  }) {
    String usernameVal = nik != null && nik.isNotEmpty ? nik : email.split('@').first;
    return registerWargaPassword(
      nik: usernameVal,
      namaLengkap: namaLengkap,
      password: password,
      email: email,
    );
  }

  UserModel? authenticateUser(String usernameOrNikOrEmail, String password, UserRole role) {
    String roleStr = role == UserRole.warga ? 'warga' : (role == UserRole.kader ? 'kader' : 'kades');
    
    // Find user by email, username, or NIK & password
    try {
      final user = _users.firstWhere(
        (u) => (u.username == usernameOrNikOrEmail || 
                u.nik == usernameOrNikOrEmail || 
                (u.email != null && u.email!.toLowerCase() == usernameOrNikOrEmail.toLowerCase())) &&
               u.password == password &&
               u.role == roleStr,
      );
      _currentUser = user;
      return user;
    } catch (_) {
      // Fallback for default demo testing if credentials match role defaults
      if ((role == UserRole.warga && (usernameOrNikOrEmail == 'warga' || usernameOrNikOrEmail.isNotEmpty) && password == '123456') ||
          (role == UserRole.kader && usernameOrNikOrEmail == 'kader' && password == '123456') ||
          (role == UserRole.kades && usernameOrNikOrEmail == 'kades' && password == '123456')) {
        final fallback = UserModel(
          id: 'demo',
          username: usernameOrNikOrEmail,
          email: role == UserRole.warga ? 'warga@japan.desa.id' : null,
          password: password,
          namaLengkap: role == UserRole.warga ? 'Warga Desa' : (role == UserRole.kader ? 'Kader Dasa Wisma' : 'Kepala Desa'),
          role: roleStr,
          nik: role == UserRole.warga ? usernameOrNikOrEmail : null,
        );
        _currentUser = fallback;
        return fallback;
      }
      return null;
    }
  }

  void addUser(UserModel user) {
    _users.add(user);
    notifyListeners();
  }

  void updateUser(UserModel user) {
    int idx = _users.indexWhere((u) => u.id == user.id);
    if (idx != -1) {
      _users[idx] = user;
      notifyListeners();
    }
  }

  void deleteUser(String id) {
    _users.removeWhere((u) => u.id == id);
    notifyListeners();
  }

  // --- BANTUAN METHODS ---

  void addMasterBantuan(String namaBantuan) {
    final b = namaBantuan.trim();
    if (b.isNotEmpty && !_masterBantuanHibah.contains(b)) {
      _masterBantuanHibah.add(b);
      notifyListeners();
    }
  }

  void addBantuanTag(String tag) => addMasterBantuan(tag);

  void removeMasterBantuan(String namaBantuan) {
    _masterBantuanHibah.remove(namaBantuan);
    notifyListeners();
  }

  void removeBantuanTag(String tag) => removeMasterBantuan(tag);

  void addBantuanRecord(String namaKepalaKeluarga, String namaBantuan, {String status = 'Disetujui', String diajukanOleh = 'Kepala Desa'}) {
    _bantuanRecordList.add(BantuanItemModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      namaKepalaKeluarga: namaKepalaKeluarga,
      namaBantuan: namaBantuan,
      status: status,
      diajukanOleh: diajukanOleh,
      tanggal: '06/09/2026',
    ));
    notifyListeners();
  }

  void setujuiBantuanRecord(String id) {
    int idx = _bantuanRecordList.indexWhere((b) => b.id == id);
    if (idx != -1) {
      final old = _bantuanRecordList[idx];
      _bantuanRecordList[idx] = BantuanItemModel(
        id: old.id,
        namaKepalaKeluarga: old.namaKepalaKeluarga,
        namaBantuan: old.namaBantuan,
        status: 'Disetujui',
        diajukanOleh: old.diajukanOleh,
        tanggal: old.tanggal,
      );

      int kkIdx = _keluargaList.indexWhere((k) => k.namaKepalaKeluarga.toLowerCase() == old.namaKepalaKeluarga.toLowerCase());
      if (kkIdx != -1) {
        updateBantuanKeluarga(_keluargaList[kkIdx].id, true, old.namaBantuan);
      }
      notifyListeners();
    }
  }

  void tolakBantuanRecord(String id) {
    int idx = _bantuanRecordList.indexWhere((b) => b.id == id);
    if (idx != -1) {
      final old = _bantuanRecordList[idx];
      _bantuanRecordList[idx] = BantuanItemModel(
        id: old.id,
        namaKepalaKeluarga: old.namaKepalaKeluarga,
        namaBantuan: old.namaBantuan,
        status: 'Ditolak',
        diajukanOleh: old.diajukanOleh,
        tanggal: old.tanggal,
      );

      int kkIdx = _keluargaList.indexWhere((k) => k.namaKepalaKeluarga.toLowerCase() == old.namaKepalaKeluarga.toLowerCase());
      if (kkIdx != -1) {
        updateBantuanKeluarga(_keluargaList[kkIdx].id, false, old.namaBantuan);
      }
      notifyListeners();
    }
  }

  void deleteBantuanRecord(String id) {
    int idx = _bantuanRecordList.indexWhere((b) => b.id == id);
    if (idx != -1) {
      final old = _bantuanRecordList[idx];
      int kkIdx = _keluargaList.indexWhere((k) => k.namaKepalaKeluarga.toLowerCase() == old.namaKepalaKeluarga.toLowerCase());
      if (kkIdx != -1) {
        updateBantuanKeluarga(_keluargaList[kkIdx].id, false, '-');
      }
      _bantuanRecordList.removeAt(idx);
      notifyListeners();
    }
  }

  void updateBantuanKeluarga(String kkId, bool isPenerima, String namaBantuan) {
    int idx = _keluargaList.indexWhere((k) => k.id == kkId);
    if (idx != -1) {
      final old = _keluargaList[idx];
      _keluargaList[idx] = KeluargaModel(
        id: old.id,
        noKk: old.noKk,
        nikHead: old.nikHead,
        namaKepalaKeluarga: old.namaKepalaKeluarga,
        desa: old.desa,
        alamat: old.alamat,
        rt: old.rt,
        rw: old.rw,
        dawis: old.dawis,
        totalAnggota: old.totalAnggota,
        jumlahLakiLaki: old.jumlahLakiLaki,
        jumlahPerempuan: old.jumlahPerempuan,
        balitaLaki: old.balitaLaki,
        balitaPerempuan: old.balitaPerempuan,
        jumlahLansia: old.jumlahLansia,
        jumlahPus: old.jumlahPus,
        jumlahWus: old.jumlahWus,
        jumlahIbuHamil: old.jumlahIbuHamil,
        jumlahIbuMenyusui: old.jumlahIbuMenyusui,
        tunaHuruf: old.tunaHuruf,
        tunaNetra: old.tunaNetra,
        tunaRungu: old.tunaRungu,
        berkebutuhanKhusus: old.berkebutuhanKhusus,
        kriteriaRumah: old.kriteriaRumah,
        tempatSampah: old.tempatSampah,
        spal: old.spal,
        jambanKeluarga: old.jambanKeluarga,
        stikerP4k: old.stikerP4k,
        sumberAir: old.sumberAir,
        makananPokok: old.makananPokok,
        up2k: old.up2k,
        kegiatan2k: old.kegiatan2k,
        ptp: old.ptp,
        industriRt: old.industriRt,
        kerjaBakti: old.kerjaBakti,
        partisipasiKegiatan: old.partisipasiKegiatan,
        isPenerimaBantuan: isPenerima,
        namaBantuanHibah: namaBantuan,
        anggotaList: old.anggotaList,
      );
      notifyListeners();
    }
  }

  void addAnggotaKeluarga(String kkId, AnggotaKeluargaModel anggota) {
    int idx = _keluargaList.indexWhere((k) => k.id == kkId);
    if (idx != -1) {
      final old = _keluargaList[idx];
      final updatedList = List<AnggotaKeluargaModel>.from(old.anggotaList)..add(anggota);
      
      int total = updatedList.length;
      int l = updatedList.where((a) => a.jenisKelamin.toLowerCase().contains('laki')).length;
      int p = updatedList.where((a) => a.jenisKelamin.toLowerCase().contains('perempuan')).length;

      _keluargaList[idx] = KeluargaModel(
        id: old.id,
        noKk: old.noKk,
        nikHead: old.nikHead,
        namaKepalaKeluarga: old.namaKepalaKeluarga,
        desa: old.desa,
        alamat: old.alamat,
        rt: old.rt,
        rw: old.rw,
        dawis: old.dawis,
        totalAnggota: total,
        jumlahLakiLaki: l,
        jumlahPerempuan: p,
        balitaLaki: old.balitaLaki,
        balitaPerempuan: old.balitaPerempuan,
        jumlahLansia: old.jumlahLansia,
        jumlahPus: old.jumlahPus,
        jumlahWus: old.jumlahWus,
        jumlahIbuHamil: old.jumlahIbuHamil,
        jumlahIbuMenyusui: old.jumlahIbuMenyusui,
        tunaHuruf: old.tunaHuruf,
        tunaNetra: old.tunaNetra,
        tunaRungu: old.tunaRungu,
        berkebutuhanKhusus: old.berkebutuhanKhusus,
        kriteriaRumah: old.kriteriaRumah,
        tempatSampah: old.tempatSampah,
        spal: old.spal,
        jambanKeluarga: old.jambanKeluarga,
        stikerP4k: old.stikerP4k,
        sumberAir: old.sumberAir,
        makananPokok: old.makananPokok,
        up2k: old.up2k,
        kegiatan2k: old.kegiatan2k,
        ptp: old.ptp,
        industriRt: old.industriRt,
        kerjaBakti: old.kerjaBakti,
        partisipasiKegiatan: old.partisipasiKegiatan,
        isPenerimaBantuan: old.isPenerimaBantuan,
        namaBantuanHibah: old.namaBantuanHibah,
        anggotaList: updatedList,
      );
      notifyListeners();
    }
  }

  List<KeluargaModel> get filteredKeluargaList {
    if (_selectedDawis == 'Semua Dawis' || _selectedDawis.trim().isEmpty) {
      return _keluargaList;
    }
    return _keluargaList.where((k) => k.dawis.trim().toLowerCase() == _selectedDawis.trim().toLowerCase()).toList();
  }

  int get totalKK => filteredKeluargaList.length;
  int get totalWarga => filteredKeluargaList.fold(0, (sum, k) {
    int val = k.totalAnggota > 0 ? k.totalAnggota : (k.jumlahLakiLaki + k.jumlahPerempuan);
    return sum + (val > 0 ? val : k.anggotaList.length);
  });
  int get totalBalita => filteredKeluargaList.fold(0, (sum, k) => sum + k.totalBalita);
  int get totalLansia => filteredKeluargaList.fold(0, (sum, k) => sum + k.jumlahLansia);
  int get totalLaki => filteredKeluargaList.fold(0, (sum, k) {
    int demografiL = k.balitaLaki + k.jumlahLansia + k.jumlahPus;
    return sum + (k.jumlahLakiLaki > 0 ? k.jumlahLakiLaki : demografiL);
  });
  int get totalPerempuan => filteredKeluargaList.fold(0, (sum, k) {
    int demografiP = k.balitaPerempuan + k.jumlahWus;
    return sum + (k.jumlahPerempuan > 0 ? k.jumlahPerempuan : demografiP);
  });
  int get totalPus => filteredKeluargaList.fold(0, (sum, k) => sum + k.jumlahPus);
  int get totalWus => filteredKeluargaList.fold(0, (sum, k) => sum + k.jumlahWus);
  int get totalIbuHamil => filteredKeluargaList.fold(0, (sum, k) => sum + k.jumlahIbuHamil);
  int get totalIbuMenyusui => filteredKeluargaList.fold(0, (sum, k) => sum + k.jumlahIbuMenyusui);
  int get totalTunaHuruf => filteredKeluargaList.fold(0, (sum, k) => sum + k.tunaHuruf);
  int get totalTunaNetra => filteredKeluargaList.fold(0, (sum, k) => sum + k.tunaNetra);
  int get totalTunaRungu => filteredKeluargaList.fold(0, (sum, k) => sum + k.tunaRungu);
  int get totalBerkebutuhanKhusus => filteredKeluargaList.fold(0, (sum, k) => sum + k.berkebutuhanKhusus);
  int get totalJamban => filteredKeluargaList.where((k) => k.jambanKeluarga).length;
  int get totalSampah => filteredKeluargaList.where((k) => k.tempatSampah).length;
  int get totalSpal => filteredKeluargaList.where((k) => k.spal).length;
  int get totalPdam => filteredKeluargaList.where((k) => k.sumberAir.toUpperCase().contains('PDAM')).length;
  int get totalListrik => filteredKeluargaList.length;

  void addKeluarga(KeluargaModel item) {
    _keluargaList.add(item);
    if (item.dawis.isNotEmpty) {
      addOrUpdateDawis(nama: item.dawis, rt: item.rt, rw: item.rw);
    }
    // Also auto-add/update user account if nik head is provided
    if (item.nikHead.isNotEmpty) {
      registerWargaPassword(
        nik: item.nikHead,
        namaLengkap: item.namaKepalaKeluarga,
        password: '123',
      );
    }
    notifyListeners();
  }

  void updateKeluarga(KeluargaModel item) {
    int index = _keluargaList.indexWhere((k) => k.id == item.id);
    if (index != -1) {
      _keluargaList[index] = item;
      if (item.dawis.isNotEmpty) {
        addOrUpdateDawis(nama: item.dawis, rt: item.rt, rw: item.rw);
      }
      notifyListeners();
    }
  }


  void deleteKeluarga(String id) {
    _keluargaList.removeWhere((k) => k.id == id);
    notifyListeners();
  }
}
