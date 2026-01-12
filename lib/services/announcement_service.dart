import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import '../models/announcement.dart';
import 'db_service.dart';

class AnnouncementService extends GetxController {
  final RxList<Announcement> announcements = <Announcement>[].obs;

  Future<void> fetchAnnouncements() async {
    final db = await DBService.instance.database;
    final result = await db.query('announcements', orderBy: 'date DESC');
    announcements.value = result.map((e) => Announcement.fromMap(e)).toList();
  }

  Future<void> addAnnouncement(String title, String content) async {
    final db = await DBService.instance.database;
    await db.insert('announcements', Announcement(
      title: title,
      content: content,
      date: DateTime.now().toString().split(' ')[0] 
    ).toMap());
    fetchAnnouncements();
  }
}