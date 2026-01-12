import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user.dart';
import 'db_service.dart';

class UserService extends GetxController {
  // Fungsi untuk memperbarui Room ID penghuni (Saat Booking Kamar)
  Future<void> updateTenantRoom(int userId, int roomId) async {
    final db = await DBService.instance.database;
    await db.update(
      'users',
      {'roomId': roomId.toString()},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // Fungsi tambahan jika ingin update profil (Nama)
  Future<void> updateProfile(int userId, String newName) async {
    final db = await DBService.instance.database;
    await db.update(
      'users',
      {'name': newName},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}