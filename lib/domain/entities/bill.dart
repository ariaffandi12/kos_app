class BillEntity {
  final int id;
  final String month;
  final double totalAmount;
  final String status;
  final String? proofImage;
  BillEntity({required this.id, required this.month, required this.totalAmount, required this.status, this.proofImage});
}