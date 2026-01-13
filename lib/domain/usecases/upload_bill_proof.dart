import 'dart:io';
import '../repositories/bill_repository.dart';
class UploadBillProof {
  final BillRepository repository;
  UploadBillProof(this.repository);
  Future<bool> call(int billId, File imageFile) => repository.uploadProof(billId, imageFile);
}