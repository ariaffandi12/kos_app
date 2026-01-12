import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kos_app/models/room.dart';
import 'package:kos_app/services/auth_service.dart';
import 'package:kos_app/services/room_service.dart';
import 'package:kos_app/widgets/status_badge.dart';


class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  final RoomService roomS = Get.put(RoomService());
  final AuthService authS = Get.find<AuthService>();
  final nameC = TextEditingController();
  final priceC = TextEditingController();
  final descC = TextEditingController();

  @override
  void initState() {
    super.initState();
    roomS.fetchRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Kamar"),
        actions: [
          if (authS.currentUser.value?.role == 'owner')
            IconButton(icon: const Icon(Icons.add), onPressed: _showAddRoomDialog)
        ],
      ),
      body: Obx(() => ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: roomS.rooms.length,
        itemBuilder: (ctx, i) {
          final room = roomS.rooms[i];
          return Card(
            child: ListTile(
              leading: Image.network("https://picsum.photos/seed/${room.id}/50/50", width: 50, height: 50, fit: BoxFit.cover),
              title: Text(room.name),
              subtitle: Text("Rp ${room.price} - ${room.description}"),
              trailing: StatusBadge(status: room.status),
            ),
          );
        },
      )),
    );
  }

  void _showAddRoomDialog() {
    Get.dialog(AlertDialog(
      title: const Text("Tambah Kamar"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: nameC, decoration: const InputDecoration(labelText: "Nama Kamar")),
          TextField(controller: priceC, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Harga")),
          TextField(controller: descC, decoration: const InputDecoration(labelText: "Deskripsi")),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
        ElevatedButton(
          onPressed: () {
            roomS.addRoom(Room(
              name: nameC.text,
              price: double.parse(priceC.text),
              description: descC.text,
              status: 'empty',
              imagePath: ''
            ));
            Get.back();
          },
          child: const Text("Simpan"),
        )
      ],
    ));
  }
}