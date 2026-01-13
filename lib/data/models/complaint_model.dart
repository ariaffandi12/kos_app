import '../../domain/entities/complaint.dart';
class ComplaintModel extends ComplaintEntity {
  ComplaintModel({required super.id, required super.tenantName, required super.roomNumber, required super.issue, required super.urgency, required super.status});
  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'], tenantName: json['tenant_name'], roomNumber: json['room_number'],
      issue: json['issue'], urgency: json['urgency'], status: json['status']
    );
  }
  ComplaintEntity toEntity() => this;
}