class UserEntity {
  final int id;
  final String name;
  final String email;
  final String role;
  final int? roomId;
  UserEntity({required this.id, required this.name, required this.email, required this.role, this.roomId});
}