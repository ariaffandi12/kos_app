import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/billing_service.dart';
import '../services/auth_service.dart';
import '../widgets/status_badge.dart';
import 'billing.dart';
import 'complains.dart'; // Import path baru
import 'announcement.dart';
import 'chat.dart';

class TenantDashboard extends StatelessWidget {
  TenantDashboard({super.key});

  final BillingService billS = Get.put(BillingService());

  @override
  Widget build(BuildContext context) {
    billS.fetchBills();
    final authS = Get.find<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Penghuni"),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: () => Get.find<AuthService>().logout())
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.deepPurple, Colors.purpleAccent]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.home, color: Colors.white, size: 40),
                  const SizedBox(width: 20),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                    Text("Selamat Datang", style: TextStyle(color: Colors.white70, fontSize: 14)),
                    Text("Kamar 101 - VIP", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ])
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.5),
                children: [
                  _buildMenuCard("Tagihan Saya", Icons.receipt_long, Colors.orange, () => Get.to(() => const BillingDetailScreen(isAdmin: false))),
                  _buildMenuCard("Pengumuman", Icons.announcement, Colors.red, () => Get.to(() => const AnnouncementScreen())),
                  _buildMenuCard("Keluhan", Icons.report_problem, Colors.blue, () => Get.to(() => const ComplainsScreen())), // Class baru
                  _buildMenuCard("Chat Owner", Icons.chat, Colors.green, () => Get.to(() => const ChatScreen())),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: color),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}