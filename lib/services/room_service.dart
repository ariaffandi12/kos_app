import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import '../models/room.dart';
import 'db_service.dart';

class RoomService extends GetxController {
  final RxList<Room> rooms = <Room>[].obs;

  Future<void> fetchRooms() async {
    final db = await DBService.instance.database;
    final result = await db.query('rooms');
    rooms.value = result.map((e) => Room.fromMap(e)).toList();
  }

  Future<void> addRoom(Room room) async {
    final db = await DBService.instance.database;
    await db.insert('rooms', room.toMap());
    fetchRooms();
  }

  Future<void> updateRoom(Room room) async {
    final db = await DBService.instance.database;
    await db.update('rooms', room.toMap(), where: 'id = ?', whereArgs: [room.id]);
    fetchRooms();
  }

  Future<void> deleteRoom(int id) async {
    final db = await DBService.instance.database;
    await db.delete('rooms', where: 'id = ?', whereArgs: [id]);
    fetchRooms();
  }
}