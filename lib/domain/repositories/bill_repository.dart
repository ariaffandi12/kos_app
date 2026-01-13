import 'dart:io';
import '../entities/bill.dart';
abstract class BillRepository {
  Future<bool> uploadProof(int billId, File imageFile);
  Future<List<BillEntity>> getBills(int userId);
}