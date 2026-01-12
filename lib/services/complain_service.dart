import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import '../models/complains.dart';
import 'db_service.dart';

class ComplainService extends GetxController {
  final RxList<Complain> complains = <Complain>[].obs;

  Future<void> fetchComplains() async {
    final db = await DBService.instance.database;
    final result = await db.query('complaints', orderBy: 'id DESC');
    complains.value = result.map((e) => Complain.fromMap(e)).toList();
  }

  Future<void> addComplain(Complain complain) async {
    final db = await DBService.instance.database;
    await db.insert('complaints', complain.toMap());
    fetchComplains();
  }

  Future<void> updateStatus(int id, String status) async {
    final db = await DBService.instance.database;
    await db.update('complaints', {'status': status}, where: 'id = ?', whereArgs: [id]);
    fetchComplains();
  }
}