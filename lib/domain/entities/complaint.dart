class ComplaintEntity {
  final int id;
  final String tenantName;
  final String roomNumber;
  final String issue;
  final String urgency;
  final String status;

  ComplaintEntity({
    required this.id, 
    required this.tenantName, 
    required this.roomNumber, 
    required this.issue, 
    required this.urgency, 
    required this.status
  });
}