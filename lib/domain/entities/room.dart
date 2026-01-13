class RoomEntity {
  final int id;
  final String roomNumber;
  final String type;
  final double price;
  final String status;
  final String? tenantName;
  final String? imageUrl;
  RoomEntity({required this.id, required this.roomNumber, required this.type, required this.price, required this.status, this.tenantName, this.imageUrl});
}