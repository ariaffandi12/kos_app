class Bill {
  final int? id;
  final String tenantId;
  final String month;
  final double amount;
  final String status;
  final String? proofImage;

  Bill({
    this.id,
    required this.tenantId,
    required this.month,
    required this.amount,
    required this.status,
    this.proofImage,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'tenantId': tenantId,
    'month': month,
    'amount': amount,
    'status': status,
    'proofImage': proofImage
  };

  factory Bill.fromMap(Map<String, dynamic> map) => Bill(
    id: map['id'],
    tenantId: map['tenantId'],
    month: map['month'],
    amount: map['amount'],
    status: map['status'],
    proofImage: map['proofImage'],
  );
}