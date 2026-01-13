import '../../domain/entities/room.dart';
class RoomModel extends RoomEntity {
  RoomModel({required super.id, required super.roomNumber, required super.type, required super.price, required super.status, super.tenantName, super.imageUrl});
  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'], roomNumber: json['room_number'], type: json['type'],
      price: double.parse(json['price'].toString()), status: json['status'],
      tenantName: json['tenant_name'], imageUrl: json['image_url']
    );
  }
  RoomEntity toEntity() => this;
}