import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kos_app/services/auth_service.dart';
import 'package:kos_app/services/billing_service.dart';
import 'package:kos_app/widgets/status_badge.dart';


class TenantDashboard extends StatelessWidget {
  TenantDashboard({super.key});

  final BillingService billS = Get.put(BillingService());

  @override
  Widget build(BuildContext context) {
    billS.fetchBills();
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
            const Align(alignment: Alignment.centerLeft, child: Text("Tagihan Saya", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                final myBills = billS.bills; 
                if (myBills.isEmpty) return const Center(child: Text("Tidak ada tagihan"));
                return ListView.builder(
                  itemCount: myBills.length,
                  itemBuilder: (ctx, i) {
                    final bill = myBills[i];
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.receipt_long)),
                        title: Text(bill.month),
                        subtitle: Text("Rp ${bill.amount}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: StatusBadge(status: bill.status),
                      ),
                    );
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}