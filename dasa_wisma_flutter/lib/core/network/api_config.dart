class ApiConfig {
  // Use your computer's IP address instead of localhost/127.0.0.1 for Android Emulator or physical device
  // Emulator: 10.0.2.2, Physical device: e.g. 192.168.1.5
  static const String baseUrl = 'http://10.0.2.2:8080/api'; 
  
  static const String statistikUrl = '$baseUrl/dashboard/statistik';
  static const String keluargaUrl = '$baseUrl/keluarga';
}
