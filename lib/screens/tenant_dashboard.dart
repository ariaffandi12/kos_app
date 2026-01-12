import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/billing_service.dart';
import '../services/auth_service.dart';
import 'billing.dart';
import 'complains.dart';
import 'announcement.dart';
import 'chat.dart';

class TenantDashboard extends StatelessWidget {
  TenantDashboard({super.key});

  final BillingService billS = Get.put(BillingService());

  @override
  Widget build(BuildContext context) {
    billS.fetchBills();
    final authS = Get.find<AuthService>();
    final user = authS.currentUser.value;
    final hasRoom = user?.roomId != null;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Bersih (Putih abu-abu)
      
      // 1️⃣ APP BAR
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            child: const Icon(Icons.person, size: 20),
          ),
        ),
        title: const Text("Dashboard Penghuni"),
        actions: [
          IconButton(
            onPressed: () => Get.find<AuthService>().logout(),
            icon: const Icon(Icons.logout),
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Padding screen 16
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // 2️⃣ CARD PROFIL & STATUS KAMAR (Primary Focus)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Halo,",
                      style: TextStyle(
                        fontSize: 14, 
                        color: theme.colorScheme.onSurfaceVariant
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.name ?? "Penghuni",
                      style: const TextStyle(
                        fontSize: 24, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(thickness: 1, height: 1),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Status Kamar:",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        _buildStatusBadge(hasRoom),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20), // Jarak section

            // 3️⃣ CARD INFORMASI / EMPTY STATE (Hanya jika belum punya kamar)
            if (!hasRoom) 
              Card(
                color: Colors.orange.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.orange.shade200),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange.shade700, size: 28),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Anda belum memiliki kamar. Silakan pesan kamar yang tersedia.",
                          style: TextStyle(fontSize: 13, color: Colors.black87),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                        onPressed: () => Get.toNamed('/rooms'),
                        child: const Text("Pesan Kamar"),
                      ),
                    ],
                  ),
                ),
              ),

            if (!hasRoom) const SizedBox(height: 24),

            // 4️⃣ JUDUL SECTION
            Padding(
              padding: const EdgeInsets.only(left: 4.0, bottom: 16.0),
              child: Text(
                "Menu Utama",
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface
                ),
              ),
            ),

            // 5️⃣ MENU UTAMA (Grid 2 Kolom)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16, // Jarak antar card
              crossAxisSpacing: 16,
              childAspectRatio: 1.2, // Tinggi seragam
              children: [
                _buildMenuGridItem(
                  title: "Tagihan Saya",
                  icon: Icons.receipt_long_outlined,
                  color: Colors.orange,
                  onTap: () => Get.to(() => const BillingDetailScreen(isAdmin: false)),
                ),
                _buildMenuGridItem(
                  title: "Pengumuman",
                  icon: Icons.announcement_outlined,
                  color: Colors.red,
                  onTap: () => Get.to(() => const AnnouncementScreen()),
                ),
                _buildMenuGridItem(
                  title: "Keluhan",
                  icon: Icons.report_problem_outlined,
                  color: Colors.blue,
                  onTap: () => Get.to(() => ComplainsScreen()),
                ),
                _buildMenuGridItem(
                  title: "Chat Owner",
                  icon: Icons.chat_outlined,
                  color: Colors.green,
                  onTap: () => Get.to(() => ChatScreen()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper: Badge Status Kamar
  Widget _buildStatusBadge(bool hasRoom) {
    final label = hasRoom ? "Aktif" : "Belum Pesan";
    final color = hasRoom ? Colors.green : Colors.orange;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color, 
          fontWeight: FontWeight.bold, 
          fontSize: 12
        ),
      ),
    );
  }

  // Helper: Item Menu Grid (Reusable)
  Widget _buildMenuGridItem({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13, 
                  fontWeight: FontWeight.w600,
                  color: Colors.black87
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}