import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/bill.dart';
import '../services/billing_service.dart';
import '../services/export_service.dart';
import '../services/auth_service.dart';
import '../widgets/status_badge.dart';

class BillingDetailScreen extends StatelessWidget {
  final bool isAdmin;
  const BillingDetailScreen({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final billS = Get.find<BillingService>();
    final authS = Get.find<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Tagihan"),
        actions: [
          if (!isAdmin)
            IconButton(icon: const Icon(Icons.picture_as_pdf), onPressed: () {
               final myBills = billS.bills.where((b) => b.tenantId == authS.currentUser.value!.id.toString()).toList();
               ExportService.exportBillsToPDF(myBills, authS.currentUser.value!.name);
            })
        ],
      ),
      body: Obx(() {
        final myBills = isAdmin 
            ? billS.bills 
            : billS.bills.where((b) => b.tenantId == authS.currentUser.value!.id.toString()).toList();

        if (myBills.isEmpty) return const Center(child: Text("Tidak ada data tagihan"));

        return ListView.builder(
          itemCount: myBills.length,
          itemBuilder: (ctx, i) {
            final bill = myBills[i];
            return Card(
              margin: const EdgeInsets.all(10),
              child: ExpansionTile(
                title: Text(bill.month),
                subtitle: Text("Rp ${bill.amount}"),
                trailing: StatusBadge(status: bill.status),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Status: ${bill.status.toUpperCase()}"),
                        if (!isAdmin && bill.status != 'paid')
                          ElevatedButton.icon(
                            icon: const Icon(Icons.upload_file),
                            label: const Text("Upload Bukti Pembayaran"),
                            onPressed: () async {
                              final picker = ImagePicker();
                              final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                              if (image != null) {
                                await billS.uploadProof(bill.id!, image.path);
                                Get.snackbar("Sukses", "Bukti berhasil diupload");
                              }
                            },
                          ),
                        if (bill.proofImage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text("Bukti Bayar: ${bill.proofImage}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      }),
    );
  }
}