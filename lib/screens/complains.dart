import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kos_app/models/complains.dart';
import '../services/complain_service.dart';
import '../services/auth_service.dart';
import '../widgets/status_badge.dart';

class ComplainsScreen extends StatefulWidget {
  const ComplainsScreen({super.key});

  @override
  State<ComplainsScreen> createState() => _ComplainsScreenState();
}

class _ComplainsScreenState extends State<ComplainsScreen> {
  final ComplainService compS = Get.put(ComplainService());
  final AuthService authS = Get.find<AuthService>();
  final descC = TextEditingController();
  String? _complainImagePath;

  @override
  void initState() {
    super.initState();
    compS.fetchComplains();
  }

  Future<void> _pickComplainImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _complainImagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Keluhan"),
        actions: [
          // Tombol Tambah Keluhan hanya untuk Tenant
          if (authS.currentUser.value?.role == 'tenant')
            IconButton(icon: const Icon(Icons.add), onPressed: _showAddDialog)
        ],
      ),
      body: Obx(() {
        if (compS.complains.isEmpty) {
          return const Center(child: Text("Belum ada keluhan"));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: compS.complains.length,
          itemBuilder: (ctx, i) {
            final comp = compS.complains[i];
            bool isOwner = authS.currentUser.value?.role == 'owner';
            
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tenant ID: ${comp.tenantId}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                        StatusBadge(status: comp.status),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(comp.description, style: const TextStyle(fontSize: 16)),
                    
                    // Tampilkan Foto jika ada
                    if (comp.image.isNotEmpty && File(comp.image).existsSync())
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(File(comp.image), height: 200, width: double.infinity, fit: BoxFit.cover),
                        ),
                      ),

                    const SizedBox(height: 10),

                    // PERBAIKAN ERROR: Hapus kurung kurawal { } di sini
                    if (isOwner)
                      Row(
                        children: [
                          const Text("Ubah Status: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          if (comp.status != 'pending')
                            TextButton(child: const Text("Pending", style: TextStyle(color: Colors.orange)), onPressed: () => compS.updateStatus(comp.id!, 'pending')),
                          if (comp.status != 'process')
                            TextButton(child: const Text("Proses", style: TextStyle(color: Colors.red)), onPressed: () => compS.updateStatus(comp.id!, 'process')),
                          if (comp.status != 'done')
                            TextButton(child: const Text("Selesai", style: TextStyle(color: Colors.green)), onPressed: () => compS.updateStatus(comp.id!, 'done')),
                        ],
                      )
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showAddDialog() {
    descC.clear();
    _complainImagePath = null;

    Get.dialog(AlertDialog(
      title: const Text("Kirim Keluhan"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: descC, decoration: const InputDecoration(labelText: "Deskripsi Masalah")),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt),
            label: const Text("Ambil Foto"),
            onPressed: _pickComplainImage,
          )
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
        ElevatedButton(
          onPressed: () {
            compS.addComplain(Complain(
              tenantId: authS.currentUser.value!.id.toString(),
              description: descC.text,
              image: _complainImagePath ?? '',
              status: 'pending'
            ));
            Get.back();
          },
          child: const Text("Kirim"),
        )
      ],
    ));
  }
}