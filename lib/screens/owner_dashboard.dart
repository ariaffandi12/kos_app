import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/billing_service.dart';
import '../services/room_service.dart';
import '../services/auth_service.dart';

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
    billS.generateBills(); // Simulate auto-billing
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Owner"),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: () => Get.find<AuthService>().logout())
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Statistik
            Row(
              children: [
                Expanded(child: _buildStatCard("Total Kamar", "${roomS.rooms.length}", Icons.bed, Colors.blue)),
                const SizedBox(width: 10),
                Expanded(child: _buildStatCard("Tagihan Aktif", "${billS.bills.where((b) => b.status != 'paid').length}", Icons.money, Colors.orange)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Tagihan Masuk", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (billS.bills.isEmpty) return const Center(child: Text("Belum ada tagihan"));
                return ListView.builder(
                  itemCount: billS.bills.length,
                  itemBuilder: (ctx, index) {
                    final bill = billS.bills[index];
                    return Card(
                      child: ListTile(
                        title: Text("Tenant ID: ${bill.tenantId} - ${bill.month}"),
                        subtitle: Text("Rp ${bill.amount}"),
                        trailing: StatusBadge(status: bill.status),
                      ),
                    );
                  },
                );
              }),
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
}