import 'package:flutter/foundation.dart';
import '../data/warga_service.dart';

class WargaProvider with ChangeNotifier {
  final WargaService _service = WargaService();
  
  List<dynamic> _keluargaList = [];
  bool _isLoading = false;
  String _error = '';

  List<dynamic> get keluargaList => _keluargaList;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchKeluarga({String query = ''}) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _keluargaList = await _service.fetchKeluarga(query: query);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> tambahKeluarga(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    
    bool success = false;
    try {
      success = await _service.tambahKeluarga(data);
      if (success) {
        await fetchKeluarga(); // Refresh data
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return success;
  }

  Future<bool> updateKeluarga(String id, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    
    bool success = false;
    try {
      success = await _service.updateKeluarga(id, data);
      if (success) {
        await fetchKeluarga(); // Refresh data
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return success;
  }

  Future<bool> hapusKeluarga(String keluargaId) async {
    _isLoading = true;
    notifyListeners();
    
    bool success = false;
    try {
      success = await _service.hapusKeluarga(keluargaId);
      if (success) {
        await fetchKeluarga(); // Refresh data
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return success;
  }

  Future<bool> setujuiBantuan(String anggotaId) async {
    _isLoading = true;
    notifyListeners();
    
    bool success = false;
    try {
      // Kita asumsikan ada properti is_bantuan_disetujui yang kita update ke true
      success = await _service.updateKeluarga(anggotaId, {
        'is_bantuan_disetujui': true,
        'tanggal_disetujui': DateTime.now().toIso8601String(),
      });
      
      if (success) {
        await fetchKeluarga(); // Refresh data setelah berhasil
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return success;
  }
}
