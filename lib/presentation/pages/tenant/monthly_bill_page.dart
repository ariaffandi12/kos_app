import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kos_app/core/constants/app_colors.dart';
import 'package:kos_app/presentation/widgets/custom_button.dart';
import 'package:kos_app/presentation/providers/bill_provider.dart';
import 'package:kos_app/presentation/providers/auth_provider.dart';

class MonthlyBillPage extends StatefulWidget {
  const MonthlyBillPage({super.key});
  
  @override
  State<MonthlyBillPage> createState() => _MonthlyBillPageState();
}

class _MonthlyBillPageState extends State<MonthlyBillPage> {
  File? _image;

  /// Fungsi Pilih Gambar
  Future<void> pick(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  /// Fungsi Submit Upload
  Future<void> submitUpload() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Harap pilih foto bukti pembayaran"))
      );
      return;
    }

    // Ambil user yang sedang login
    final user = context.read<AuthProvider>().user;
    if (user == null) return;

    // Ambil provider bill
    final billProv = context.read<BillProvider>();

    // Ambil ID tagihan (pilih yang first/terbaru)
    if (billProv.bills.isEmpty) return;
    
    // Gunakan non-null assertion (!) karena kita sudah yakin bill ada di sini
    final int billId = billProv.bills.first.id;

    bool success = await billProv.upload(billId, _image!);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? "Upload Berhasil!" : "Gagal Upload"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tampilkan Loading jika sedang proses upload
    final billProv = context.watch<BillProvider>();

    // Jika list bills kosong
    if (billProv.bills.isEmpty) {
      // Coba load manual jika belum ter-load (misal user belum buka halaman ini sebelumnya)
      Future.microtask(() {
         final user = context.read<AuthProvider>().user;
         if(user != null) billProv.load(user!.id);
      });
      return Center(child: Text("Loading bills..."));
    }

    // Definisi bill dengan type non-null agar operator '!' aman
    final bill = billProv.bills.isNotEmpty ? billProv.bills.first : null;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text("Monthly Bill"),
        backgroundColor: AppColors.backgroundDark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header Bill (Pastikan bill tidak null sebelum diakses)
            if (bill != null) ...[
              // Mengambil bulan/tahun langsung dari object database
              Text(
                "${bill.month} Bill", // <--- INI DARI BILL.MONTH
                style: const TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold, 
                  color: AppColors.textPrimary
                )
              ),
              const SizedBox(height: 10),
              Text(
                "Invoice ID: #${bill.id}",
                style: const TextStyle(color: Colors.grey)
              ),
              const SizedBox(height: 20),

              // Card Total
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange) // Orange border untuk unpaid
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Amount", style: TextStyle(color: Colors.white)),
                    // Menggunakan bill.totalAmount
                    Text(
                      "\$${bill.totalAmount}",
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      )
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Preview Gambar
              if (_image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(_image!, height: 200, width: double.infinity, fit: BoxFit.cover)
                ),
              
              // Tombol Pilih Gambar
              Row(
                children: [
                  Expanded(
                    child: _btn(Icons.camera, "Camera", () => pick(ImageSource.camera))
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _btn(Icons.photo_library, "Gallery", () => pick(ImageSource.gallery))
                  ),
                ],
              ),
              const Spacer(),

              // Tombol Upload
              billProv.isLoading 
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : CustomButton(
                      label: "Confirm Submission",
                      onPressed: submitUpload // Panggil fungsi di atas
                    ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _btn(IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
      ),
    );
  }
}