import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/billing_service.dart';
import '../services/room_service.dart';
import '../services/auth_service.dart';
import '../services/export_service.dart';
import '../widgets/status_badge.dart';
import 'rooms.dart';
import 'billing.dart';
import 'complains.dart'; // Import path baru
import 'announcement.dart';
import 'chat.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({super.key});

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  final BillingService billS = Get.put(BillingService());
  final RoomService roomS = Get.put(RoomService());

  @override
  void initState() {
    super.initState();
    billS.fetchBills();
    roomS.fetchRooms();
    billS.generateBills();
  }

  @override
  Widget build(BuildContext context) {
    final authS = Get.find<AuthService>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Owner"),
        actions: [
          IconButton(icon: const Icon(Icons.picture_as_pdf), onPressed: () {
             ExportService.exportBillsToPDF(billS.bills, "Laporan_Owner");
          }),
          IconButton(icon: const Icon(Icons.announcement), onPressed: () => Get.to(() => const AnnouncementScreen())),
          IconButton(icon: const Icon(Icons.logout), onPressed: () => Get.find<AuthService>().logout())
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildStatCard("Total Kamar", "${roomS.rooms.length}", Icons.bed, Colors.blue)),
                const SizedBox(width: 10),
                Expanded(child: _buildStatCard("Tagihan Aktif", "${billS.bills.where((b) => b.status != 'paid').length}", Icons.money, Colors.orange)),
              ],
            ),
            const SizedBox(height: 20),
            const Align(alignment: Alignment.centerLeft, child: Text("Menu Utama", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            const SizedBox(height: 10),
            Expanded(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.5),
                children: [
                  _buildMenuCard("Kelola Kamar", Icons.bed, () => Get.to(() => const RoomsScreen())),
                  _buildMenuCard("Verifikasi Bayar", Icons.receipt_long, () => Get.to(() => const BillingDetailScreen(isAdmin: true))),
                  _buildMenuCard("Keluhan", Icons.report_problem, () => Get.to(() => const ComplainsScreen())), // Class baru
                  _buildMenuCard("Chat", Icons.chat, () => Get.to(() => const ChatScreen())),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(title, style: const TextStyle(color: Colors.grey)),
              Icon(icon, color: color, size: 30)
            ]),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(String title, IconData icon, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.deepPurple),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}