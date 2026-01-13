import '../entities/room.dart';
abstract class RoomRepository {
  Future<List<RoomEntity>> getRooms();
}