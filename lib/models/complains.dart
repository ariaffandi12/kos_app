class Complaint {
  final int? id;
  final String tenantId;
  final String description;
  final String image;
  final String status; // 'pending', 'process', 'done'

  Complaint({
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

  factory Complaint.fromMap(Map<String, dynamic> map) => Complaint(
    id: map['id'],
    tenantId: map['tenantId'],
    description: map['description'],
    image: map['image'],
    status: map['status'],
  );
}