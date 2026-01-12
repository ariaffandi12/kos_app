import 'package:get/get.dart';
import 'package:kos_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'db_service.dart';

class AuthService extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final Rx<User?> currentUser = Rxn<User>();

  Future<bool> login(String email, String password) async {
    final db = await DBService.instance.database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      final user = User.fromMap(result.first);
      currentUser.value = user;
      final prefs = await _prefs;
      await prefs.setInt('userId', user.id!);
      return true;
    }
    return false;
  }

  Future<void> register(String name, String email, String password, String role) async {
    final db = await DBService.instance.database;
    await db.insert('users', User(
      name: name,
      email: email,
      password: password,
      role: role
    ).toMap());
  }

  Future<void> checkSession() async {
    final prefs = await _prefs;
    final userId = prefs.getInt('userId');
    if (userId != null) {
      final db = await DBService.instance.database;
      final result = await db.query('users', where: 'id = ?', whereArgs: [userId]);
      if (result.isNotEmpty) {
        currentUser.value = User.fromMap(result.first);
      }
    }
  }

  Future<void> logout() async {
    final prefs = await _prefs;
    await prefs.clear();
    currentUser.value = null;
    Get.offAllNamed('/login');
  }
}