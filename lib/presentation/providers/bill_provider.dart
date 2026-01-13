import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/bill.dart';
import '../../domain/usecases/upload_bill_proof.dart';
import '../../domain/usecases/get_bills.dart';

class BillProvider with ChangeNotifier {
  final UploadBillProof uploadProof;
  final GetBills getBills;
  
  List<BillEntity> _bills = [];
  bool _isLoading = false;

  List<BillEntity> get bills => _bills;
  bool get isLoading => _isLoading;

  BillProvider({required this.uploadProof, required this.getBills});

  // Fungsi Load Bill
  Future<void> load(int userId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _bills = await getBills(userId);
      // Tambahkan sorting descending (Agar bulan terbaru di atas)
      _bills.sort((a, b) => b.id.compareTo(a.id));
    } catch (e) {
      print("Error loading bills: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi Upload (Mengembalikan Bool, bukan menampilkan SnackBar langsung)
  Future<bool> upload(int billId, File image) async {
    _isLoading = true;
    notifyListeners();

    try {
      bool success = await uploadProof(billId, image);
      return success;
    } catch (e) {
      print("Error upload: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}