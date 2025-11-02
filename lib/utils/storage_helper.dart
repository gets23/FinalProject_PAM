import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  // Ini adalah 'kunci' untuk ingatan
  static const String _sessionKey = 'current_user_id';

  // Saat login, simpan ID user
  static Future<void> saveSession(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sessionKey, userId);
  }

  // Saat splash screen, cek ada ingatan?
  static Future<int?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_sessionKey);
  }

  // Saat logout, hapus ingatan
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}