import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/announcement_service.dart';
import '../services/auth_service.dart';

class AnnouncementScreen extends StatelessWidget {
  const AnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final annS = Get.put(AnnouncementService());
    final authS = Get.find<AuthService>();
    
    annS.fetchAnnouncements();
    final titleC = TextEditingController();
    final contentC = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengumuman Kos"),
        actions: [
          if (authS.currentUser.value!.role == 'owner')
            IconButton(
              icon: const Icon(Icons.add_alert),
              onPressed: () => Get.dialog(AlertDialog(
                title: const Text("Buat Pengumuman"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: titleC, decoration: const InputDecoration(labelText: "Judul")),
                    TextField(controller: contentC, maxLines: 3, decoration: const InputDecoration(labelText: "Isi Pengumuman")),
                  ],
                ),
                actions: [
                  TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
                  ElevatedButton(
                    onPressed: () {
                      annS.addAnnouncement(titleC.text, contentC.text);
                      Get.back();
                    },
                    child: const Text("Kirim"),
                  )
                ],
              ))
            )
        ],
      ),
      body: Obx(() {
        if (annS.announcements.isEmpty) {
          return const Center(child: Text("Belum ada pengumuman"));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: annS.announcements.length,
          itemBuilder: (ctx, i) {
            final ann = annS.announcements[i];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.notifications_active, color: Colors.deepPurple),
                title: Text(ann.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("${ann.date}\n${ann.content}"),
              ),
            );
          },
        );
      }),
    );
  }
}