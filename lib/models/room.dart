class Room {
  final int? id;
  final String name;
  final double price;
  final String description;
  final String status;
  final String imagePath;

  Room({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.status,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'price': price,
    'description': description,
    'status': status,
    'imagePath': imagePath
  };
  
  factory Room.fromMap(Map<String, dynamic> map) => Room(
    id: map['id'],
    name: map['name'],
    price: map['price'],
    description: map['description'],
    status: map['status'],
    imagePath: map['imagePath'] ?? '',
  );
}