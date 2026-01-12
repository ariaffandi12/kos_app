class User {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String role; // 'owner' atau 'tenant'
  final String? roomId;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.roomId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'roomId': roomId
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
      roomId: map['roomId'],
    );
  }
}