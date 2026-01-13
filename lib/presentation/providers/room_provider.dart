import 'package:flutter/material.dart';
import '../../domain/entities/room.dart';
import '../../domain/usecases/get_rooms.dart';

class RoomProvider with ChangeNotifier {
  final GetRooms getRooms;
  
  List<RoomEntity> _rooms = [];
  String _filter = 'All';
  bool _isLoading = false; // Tambahkan variabel ini

  // 1. Getter yang dibutuhkan oleh RoomManagementPage (Mengatasi Error Anda)
  String get currentFilter => _filter; 
  
  // 2. Getter list yang difilter
  List<RoomEntity> get filteredRooms {
    if (_filter == 'All') return _rooms;
    return _rooms.where((r) => r.status == _filter).toList();
  }

  bool get isLoading => _isLoading; // Fix getter loading

  RoomProvider({required this.getRooms});

  Future<void> loadRooms() async {
    _isLoading = true;
    notifyListeners();
    try {
      _rooms = await getRooms();
    } catch (e) {
      print("Error load rooms: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }
}