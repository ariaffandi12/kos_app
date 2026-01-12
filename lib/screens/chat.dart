import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kos_app/services/auth_service.dart';
import 'package:kos_app/services/chat_service.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // PERBAIKAN: Pastikan sintaks Get.find benar (tanpa spasi berlebih di <>)
  final ChatService chatS = Get.put(ChatService());
  final AuthService authS = Get.find<AuthService>();
  final msgC = TextEditingController();
  final ScrollController scrollC = ScrollController();

  @override
  void initState() {
    super.initState();
    chatS.fetchChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (chatS.chats.isEmpty) return const Center(child: Text("Belum ada pesan"));
              return ListView.builder(
                controller: scrollC,
                itemCount: chatS.chats.length,
                itemBuilder: (ctx, i) {
                  final chat = chatS.chats[i];
                  // Logika sederhana untuk menentukan pesan sendiri atau orang lain
                  // Jika role owner dan sender adalah admin -> send
                  // Jika role tenant dan sender id sama dengan user id -> send
                  bool isMe = (authS.currentUser.value?.role == 'owner' && chat.senderId == 'admin') ||
                               (authS.currentUser.value?.id.toString() == chat.senderId);

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.deepPurple : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(chat.message, style: TextStyle(color: isMe ? Colors.white : Colors.black)),
                    ),
                  );
                },
              );
            }),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(child: TextField(controller: msgC, decoration: const InputDecoration(hintText: "Ketik pesan..."))),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (msgC.text.isNotEmpty) {
                      String sender = (authS.currentUser.value?.role == 'owner') ? 'admin' : authS.currentUser.value!.id.toString();
                      // Logic receiver sederhana: jika owner -> kirim ke user 1, jika user -> kirim ke admin
                      String receiver = (sender == 'admin') ? '1' : 'admin'; 
                      
                      chatS.sendMessage(sender, receiver, msgC.text);
                      msgC.clear();
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}