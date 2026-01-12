import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kos_app/models/room.dart';
import '../services/room_service.dart';
import '../services/auth_service.dart';
import '../widgets/status_badge.dart';

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
  
  String? _selectedImagePath; 

  @override
  void initState() {
    super.initState();
    roomS.fetchRooms();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
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
              leading: _buildRoomImage(room.imagePath),
              title: Text(room.name),
              subtitle: Text("Rp ${room.price} - ${room.description}"),
              trailing: StatusBadge(status: room.status),
            ),
          );
        },
      )),
    );
  }

  Widget _buildRoomImage(String path) {
    if (path.isEmpty) {
      return const CircleAvatar(child: Icon(Icons.bed));
    }
    final file = File(path);
    if (file.existsSync()) {
      return CircleAvatar(backgroundImage: FileImage(file), radius: 25);
    }
    return const CircleAvatar(child: Icon(Icons.broken_image));
  }

  void _showAddRoomDialog() {
    nameC.clear();
    priceC.clear();
    descC.clear();
    _selectedImagePath = null;

    Get.dialog(AlertDialog(
      title: const Text("Tambah Kamar"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameC, decoration: const InputDecoration(labelText: "Nama Kamar")),
            TextField(controller: priceC, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Harga")),
            TextField(controller: descC, decoration: const InputDecoration(labelText: "Deskripsi")),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(onPressed: _pickImage, child: const Text("Pilih Foto")),
                const SizedBox(width: 10),
                Expanded(child: Text(_selectedImagePath?.split('/').last ?? "Tidak ada foto")),
              ],
            )
          ],
        ),
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
              imagePath: _selectedImagePath ?? ''
            ));
            Get.back();
          },
          child: const Text("Simpan"),
        )
      ],
    ));
  }
}