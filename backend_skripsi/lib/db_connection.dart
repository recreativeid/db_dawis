import 'package:mysql1/mysql1.dart';

class DbConnection {
  static Future<MySqlConnection> getConnection() async {
    final settings = ConnectionSettings(
      host: 'localhost', 
      port: 3306,
      user: 'root', // Sesuaikan user DB Anda
      password: '', // Sesuaikan password DB Anda
      db: 'db_pendataandawis', // Nama database Anda
    );
    return await MySqlConnection.connect(settings);
  }
}