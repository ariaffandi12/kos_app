import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kos_app/models/room.dart';
import '../services/room_service.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart'; // Import service baru
import '../models/user.dart'; // Import model user untuk update session
import '../widgets/status_badge.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  final RoomService roomS = Get.put(RoomService());
  final UserService userS = Get.put(UserService()); // Inisialisasi service baru
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

  // Fungsi Booking Kamar untuk Tenant (Menggunakan UserService)
  Future<void> _bookRoom(int roomId) async {
    Get.defaultDialog(
      title: "Konfirmasi",
      middleText: "Apakah Anda yakin ingin memesan kamar ini?",
      textConfirm: "Ya, Pesan",
      textCancel: "Batal",
      onConfirm: () async {
        // 1. Update status kamar jadi 'occupied'
        final room = roomS.rooms.firstWhere((r) => r.id == roomId);
        await roomS.updateRoom(Room(
          id: room.id,
          name: room.name,
          price: room.price,
          description: room.description,
          status: 'occupied',
          imagePath: room.imagePath
        ));

        // 2. Update User (Penghuni) agar memiliki roomId via UserService
        await userS.updateTenantRoom(authS.currentUser.value!.id!, roomId);

        // 3. Refresh data user saat ini di memori (Session)
        authS.currentUser.value = User(
          id: authS.currentUser.value!.id,
          name: authS.currentUser.value!.name,
          email: authS.currentUser.value!.email,
          password: authS.currentUser.value!.password,
          role: authS.currentUser.value!.role,
          roomId: roomId.toString() // Update roomId di session user
        );

        Get.back();
        Get.snackbar("Berhasil", "Kamar berhasil dipesan!", backgroundColor: Colors.green);
        setState(() {}); // Refresh UI screen
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Kamar"),
        actions: [
          // Tombol Tambah hanya untuk Owner
          if (authS.currentUser.value?.role == 'owner')
            IconButton(icon: const Icon(Icons.add), onPressed: _showAddRoomDialog)
        ],
      ),
      body: Obx(() => ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: roomS.rooms.length,
        itemBuilder: (ctx, i) {
          final room = roomS.rooms[i];
          bool isTenant = authS.currentUser.value?.role == 'tenant';
          
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation:3,
            child: Column(
              children: [
                ListTile(
                  leading: _buildRoomImage(room.imagePath),
                  title: Text(room.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Rp ${room.price}"),
                  trailing: StatusBadge(status: room.status),
                ),
                // Tombol booking hanya muncul untuk Tenant jika kamar kosong
                if (isTenant && room.status == 'empty')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0, left: 16.0, right: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.bed),
                        label: const Text("Pesan Kamar Ini"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                        onPressed: () => _bookRoom(room.id!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8)
              ],
            ),
          );
        },
      )),
    );
  }

  Widget _buildRoomImage(String path) {
    if (path.isEmpty) {
      return const CircleAvatar(child: Icon(Icons.bed), backgroundColor: Colors.grey);
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
                Expanded(child: Text(_selectedImagePath?.split('/').last ?? "Tidak ada foto", overflow: TextOverflow.ellipsis)),
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