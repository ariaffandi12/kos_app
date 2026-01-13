import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'Available': color = Colors.green; break;
      case 'Occupied': color = Colors.grey; break;
      case 'Maintenance': color = Colors.orange; break;
      case 'Pending': color = Colors.orange; break;
      case 'Resolved': color = Colors.green; break;
      case 'Active': color = Colors.green; break;
      default: color = Colors.white;
    }
    return Chip(
      label: Text(status, style: TextStyle(color: Colors.white, fontSize: 11)),
      backgroundColor: color,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      visualDensity: VisualDensity(horizontal: -4, vertical: -4)
    );
  }
}