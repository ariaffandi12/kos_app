import 'package:shared_preferences/shared_preferences.dart';
class LocalDataSource {
  Future<void> saveSession(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userId);
  }
  Future<int?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}