import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kos_app/models/complains.dart';
import 'package:kos_app/services/auth_service.dart';
import 'package:kos_app/services/complain_service.dart';
import 'package:kos_app/widgets/status_badge.dart';


class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  final ComplaintService compS = Get.put(ComplaintService());
  final AuthService authS = Get.find<AuthService>();
  final descC = TextEditingController();

  @override
  void initState() {
    super.initState();
    compS.fetchComplaints();
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
        itemCount: compS.complaints.length,
        itemBuilder: (ctx, i) {
          final comp = compS.complaints[i];
          bool isOwner = authS.currentUser.value?.role == 'owner';
          
          return Card(
            child: ListTile(
              title: Text("Tenant ID: ${comp.tenantId}"),
              subtitle: Text(comp.description),
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
    Get.dialog(AlertDialog(
      title: const Text("Kirim Keluhan"),
      content: TextField(controller: descC, decoration: const InputDecoration(labelText: "Deskripsi Masalah")),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
        ElevatedButton(
          onPressed: () {
            compS.addComplaint(Complaint(
              tenantId: authS.currentUser.value!.id.toString(),
              description: descC.text,
              image: '',
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