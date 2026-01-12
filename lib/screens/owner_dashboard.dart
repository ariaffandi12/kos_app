import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/billing_service.dart';
import '../services/room_service.dart';
import '../services/auth_service.dart';
import '../services/export_service.dart';
import '../widgets/status_badge.dart';
import 'rooms.dart';
import 'billing.dart';
import 'complains.dart';
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
    final theme = Theme.of(context);
    final pendingBills = billS.bills.where((b) => b.status != 'paid').length;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      // 1️⃣ APP BAR
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            child: const Icon(Icons.admin_panel_settings, size: 20),
          ),
        ),
        title: const Text("Dashboard Owner"),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => ExportService.exportBillsToPDF(billS.bills, "Laporan_Owner"),
            tooltip: "Export Laporan",
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authS.logout(),
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2️⃣ CARD RINGKASAN STATISTIK (Row)
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: "Total Kamar",
                    value: "${roomS.rooms.length}",
                    icon: Icons.bed_outlined,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    title: "Tagihan Aktif",
                    value: "${billS.bills.where((b) => b.status != 'paid').length}",
                    icon: Icons.money_outlined,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 3️⃣ CARD REMINDER (Jika ada tagihan pending)
            if (pendingBills > 0)
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
                      Icon(Icons.notification_important_outlined, color: Colors.orange.shade700, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Perhatian", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text("Ada $pendingBills tagihan menunggu verifikasi.", style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                        onPressed: () => Get.to(() => const BillingDetailScreen(isAdmin: true)),
                        child: const Text("Verifikasi"),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 24),

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
            
            // 5️⃣ MENU UTAMA (Grid)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildMenuGridItem(
                  title: "Kelola Kamar",
                  icon: Icons.bed_outlined,
                  color: Colors.blue,
                  onTap: () => Get.to(() => const RoomsScreen()),
                ),
                _buildMenuGridItem(
                  title: "Verifikasi Bayar",
                  icon: Icons.receipt_long_outlined,
                  color: Colors.orange,
                  onTap: () => Get.to(() => const BillingDetailScreen(isAdmin: true)),
                ),
                _buildMenuGridItem(
                  title: "Keluhan",
                  icon: Icons.report_problem_outlined,
                  color: Colors.blue,
                  onTap: () => Get.to(() => ComplainsScreen()),
                ),
                _buildMenuGridItem(
                  title: "Pengumuman",
                  icon: Icons.announcement_outlined,
                  color: Colors.red,
                  onTap: () => Get.to(() => const AnnouncementScreen()),
                ),
                _buildMenuGridItem(
                  title: "Chat",
                  icon: Icons.chat_outlined,
                  color: Colors.green,
                  onTap: () => Get.to(() => ChatScreen()),
                ),
                _buildMenuGridItem(
                  title: "Export Laporan",
                  icon: Icons.file_download_outlined,
                  color: Colors.purple,
                  onTap: () => ExportService.exportBillsToPDF(billS.bills, "Laporan_Owner_Extra"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper: Card Statistik (Angka Besar)
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12, 
                      color: Colors.grey.shade600
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 22, 
                      fontWeight: FontWeight.bold, // Fokus Utama
                      color: Colors.black87
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper: Item Menu Grid (Sama dengan Tenant untuk konsistensi)
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