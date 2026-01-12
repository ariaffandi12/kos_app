class Chat {
  final int? id;
  final String senderId; // 'admin' or user id
  final String receiverId;
  final String message;
  final String timestamp;

  Chat({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'senderId': senderId,
    'receiverId': receiverId,
    'message': message,
    'timestamp': timestamp
  };

  factory Chat.fromMap(Map<String, dynamic> map) => Chat(
    id: map['id'],
    senderId: map['senderId'],
    receiverId: map['receiverId'],
    message: map['message'],
    timestamp: map['timestamp'],
  );
}