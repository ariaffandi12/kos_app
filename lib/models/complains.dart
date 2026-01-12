class Complain {
  final int? id;
  final String tenantId;
  final String description;
  final String image;
  final String status; 

  Complain({
    this.id,
    required this.tenantId,
    required this.description,
    required this.image,
    required this.status,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'tenantId': tenantId,
    'description': description,
    'image': image,
    'status': status
  };

  factory Complain.fromMap(Map<String, dynamic> map) => Complain(
    id: map['id'],
    tenantId: map['tenantId'],
    description: map['description'],
    image: map['image'],
    status: map['status'],
  );
}