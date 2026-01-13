import 'package:flutter/material.dart';
import 'package:kos_app/presentation/widgets/custom_card.dart';
import 'package:kos_app/presentation/widgets/status_badge.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/room_provider.dart'; // Import Logic dari atas


// INI ADALAH UI MURNI (Widget)
class RoomManagementPage extends StatelessWidget {
  const RoomManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text("Room Management"), 
        backgroundColor: AppColors.backgroundDark,
      ),
      body: Consumer<RoomProvider>(
        builder: (ctx, prov, _) {
          // Load data jika kosong
          if (prov.filteredRooms.isEmpty) {
             Future.microtask(() => prov.loadRooms());
          }
          
          return Column(
            children: [
              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  children: ["All", "Available", "Occupied", "Maintenance"].map((f) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(f, style: TextStyle(color: prov.filteredRooms.isEmpty || prov.filteredRooms.first.status != f ? Colors.black : Colors.white)),
                        selected: prov.currentFilter == f,
                        onSelected: (_) => prov.setFilter(f),
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.surfaceDark,
                      ),
                    );
                  }).toList()
                ),
              ),
              Expanded(
                child: prov.isLoading 
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: prov.filteredRooms.length,
                        itemBuilder: (ctx, i) {
                          final room = prov.filteredRooms[i];
                          return CustomCard(
                            child: ListTile(
                              leading: const Icon(Icons.bedroom_parent, color: AppColors.primary),
                              title: Text("Room ${room.roomNumber}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              subtitle: Text("${room.type} • ${room.price}", style: const TextStyle(color: Colors.grey)),
                              trailing: StatusBadge(status: room.status),
                            ),
                          );
                        },
                      ),
              )
            ],
          );
        },
      ),
    );
  }
}