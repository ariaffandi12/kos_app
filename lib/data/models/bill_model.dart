import '../../domain/entities/bill.dart';
class BillModel extends BillEntity {
  BillModel({required super.id, required super.month, required super.totalAmount, required super.status, super.proofImage});
  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(id: json['id'], month: json['month'], totalAmount: double.parse(json['total_amount'].toString()), status: json['status'], proofImage: json['proof_image']);
  }
  BillEntity toEntity() => this;
}