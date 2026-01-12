import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import '../models/chat.dart';
import 'db_service.dart';

class ChatService extends GetxController {
  final RxList<Chat> chats = <Chat>[].obs;

  Future<void> fetchChats() async {
    final db = await DBService.instance.database;
    final result = await db.query('chats', orderBy: 'timestamp ASC');
    chats.value = result.map((e) => Chat.fromMap(e)).toList();
  }

  Future<void> sendMessage(String senderId, String receiverId, String message) async {
    final db = await DBService.instance.database;
    await db.insert('chats', Chat(
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      timestamp: DateTime.now().toString(),
    ).toMap());
    fetchChats();
  }
}