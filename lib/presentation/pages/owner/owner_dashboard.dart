import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/room_provider.dart';
import '../../router.dart';

class OwnerDashboard extends StatelessWidget {
  const OwnerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        title: Text("Owner Dashboard"),
        actions: [
          Icon(Icons.notifications),
          SizedBox(width: 15)
        ],
      ),
      body: Consumer<RoomProvider>(
        builder: (ctx, roomProv, _) {
          if (roomProv.filteredRooms.isEmpty) {
            Future.microtask(() => roomProv.loadRooms());
          }
          
          final occupied = roomProv.filteredRooms.where((r) => r.status == 'Occupied').length;
          final total = roomProv.filteredRooms.length;

          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // Stats
                Row(
                  children: [
                    _statCard("Occupancy", "$occupied/$total", Colors.blue),
                    SizedBox(width: 15),
                    _statCard("Pending", "03", Colors.orange)
                  ],
                ),
                SizedBox(height: 20),

                // Revenue
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(color: AppColors.surfaceDark, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Monthly Revenue", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text("Rp 45.000.000", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      Container(
                        height: 100,
                        color: AppColors.primary.withOpacity(0.2),
                        margin: EdgeInsets.only(top: 20),
                        child: Center(child: Text("Chart Visualization"))
                      )
                    ]
                  )
                ),
                SizedBox(height: 30),

                // Quick Actions
                Row(
                  children: [
                    Expanded(child: _actionCard(Icons.add_circle, "Add Room", Colors.blue, () {})),
                    SizedBox(width: 15),
                    Expanded(child: _actionCard(Icons.build, "Expenses", Colors.green, () {}))
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(child: _actionCard(Icons.campaign, "Announcements", Colors.purple, () {})),
                    SizedBox(width: 15),
                    Expanded(child: _actionCard(Icons.description, "Reports", Colors.grey, () {}))
                  ],
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: AppColors.backgroundDark,
        selectedItemColor: AppColors.primary,
        onTap: (i) {
          if (i == 1) Navigator.pushNamed(context, AppRoutes.roomManagement);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dash"),
          BottomNavigationBarItem(icon: Icon(Icons.apartment), label: "Rooms")
        ],
      ),
    );
  }

  Widget _statCard(String title, String val, Color c) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(color: AppColors.surfaceDark, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.grey, fontSize: 12)),
            SizedBox(height: 5),
            Text(val, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _actionCard(IconData icon, String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(color: AppColors.surfaceDark, borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Icon(icon, color: color, size: 30),
              SizedBox(height: 5),
              Text(label, style: TextStyle(color: Colors.white, fontSize: 12))
            ],
          ),
        ),
      ),
    );
  }
}