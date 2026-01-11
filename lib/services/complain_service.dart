import 'package:get/get.dart';
import 'package:kos_app/models/complains.dart';
import 'package:sqflite/sqflite.dart';

import 'db_service.dart';

class ComplaintService extends GetxController {
  final RxList<Complaint> complaints = <Complaint>[].obs;

  Future<void> fetchComplaints() async {
    final db = await DBService.instance.database;
    final result = await db.query('complaints', orderBy: 'id DESC');
    complaints.value = result.map((e) => Complaint.fromMap(e)).toList();
  }

  Future<void> addComplaint(Complaint complaint) async {
    final db = await DBService.instance.database;
    await db.insert('complaints', complaint.toMap());
    fetchComplaints();
  }

  Future<void> updateStatus(int id, String status) async {
    final db = await DBService.instance.database;
    await db.update('complaints', {'status': status}, where: 'id = ?', whereArgs: [id]);
    fetchComplaints();
  }
}