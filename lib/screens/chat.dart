import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/chat_service.dart';
import '../services/auth_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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