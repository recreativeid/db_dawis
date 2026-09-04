import 'package:flutter/foundation.dart';
import '../data/dashboard_service.dart';

class DashboardProvider with ChangeNotifier {
  final DashboardService _service = DashboardService();
  
  Map<String, dynamic>? _statistik;
  bool _isLoading = false;
  String _error = '';

  Map<String, dynamic>? get statistik => _statistik;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchStatistik() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _statistik = await _service.fetchStatistik();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
