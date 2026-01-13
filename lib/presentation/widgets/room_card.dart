import 'package:flutter/material.dart';
import 'package:kos_app/presentation/widgets/custom_card.dart';
import '../../core/constants/app_colors.dart';
import '../../domain/entities/room.dart';
import 'status_badge.dart';
class RoomCard extends StatelessWidget {
  final RoomEntity room;
  const RoomCard({super.key, required this.room});
  @override
  Widget build(BuildContext context) => CustomCard(child: ListTile(
    leading: Icon(Icons.bedroom_parent, color: AppColors.primary),
    title: Text("Room ${room.roomNumber}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    subtitle: Text("${room.type} • ${room.price}", style: TextStyle(color: Colors.grey)),
    trailing: StatusBadge(status: room.status),
  ));
}