import '../../domain/entities/user.dart';
class UserModel extends UserEntity {
  UserModel({required super.id, required super.name, required super.email, required super.role, super.roomId});
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'], name: json['name'], email: json['email'], role: json['role'], roomId: json['room_id']);
  }
  UserEntity toEntity() => this;
}