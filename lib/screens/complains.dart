import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kos_app/models/complains.dart';
import '../services/complain_service.dart'; // Import service baru
import '../services/auth_service.dart';
import '../widgets/status_badge.dart';

class ComplainsScreen extends StatefulWidget {
  const ComplainsScreen({super.key});

  @override
  State<ComplainsScreen> createState() => _ComplainsScreenState();
}

class _ComplainsScreenState extends State<ComplainsScreen> {
  final ComplainService compS = Get.put(ComplainService()); // Class Service baru
  final AuthService authS = Get.find<AuthService>();
  final descC = TextEditingController();
  String? _complainImagePath;

  @override
  void initState() {
    super.initState();
    compS.fetchComplains(); // Method baru
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
          if (authS.currentUser.value?.role == 'tenant')
            IconButton(icon: const Icon(Icons.add), onPressed: _showAddDialog)
        ],
      ),
      body: Obx(() => ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: compS.complains.length, // List variable baru
        itemBuilder: (ctx, i) {
          final comp = compS.complains[i];
          bool isOwner = authS.currentUser.value?.role == 'owner';
          
          return Card(
            child: ListTile(
              title: Text("Tenant ID: ${comp.tenantId}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(comp.description),
                  if (comp.image.isNotEmpty && File(comp.image).existsSync())
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Image.file(File(comp.image), height: 100, width: 100),
                    )
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StatusBadge(status: comp.status),
                  if (isOwner && comp.status != 'done')
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () => compS.updateStatus(comp.id!, 'done'),
                    )
                ],
              ),
            ),
          );
        },
      )),
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
            compS.addComplain(Complain( // Model Class baru
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