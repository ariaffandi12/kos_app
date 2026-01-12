import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final authS = Get.find<AuthService>();
  final RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.deepPurple, Colors.purpleAccent], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50),
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                // Perbaikan withOpacity -> withValues
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, spreadRadius: 0)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("Buat Akun Baru", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                  const SizedBox(height: 20),
                  
                  // Perbaikan: Menghapus const di InputDecoration karena iconnya adalah objek dinamis
                  TextFormField(
                    controller: nameC, 
                    decoration: InputDecoration(
                      labelText: "Nama Lengkap", 
                      prefixIcon: const Icon(Icons.person_outlined), // Perbaikan nama icon
                      border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  TextFormField(
                    controller: emailC, 
                    decoration: InputDecoration(
                      labelText: "Email", 
                      prefixIcon: const Icon(Icons.email_outlined), // Perbaikan nama icon
                      border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  TextFormField(
                    controller: passC, 
                    obscureText: true, 
                    decoration: InputDecoration(
                      labelText: "Password", 
                      prefixIcon: const Icon(Icons.lock_outlined), // Perbaikan nama icon
                      border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  Obx(() => CustomButton(
                    text: "DAFTAR",
                    isLoading: isLoading.value,
                    onPressed: () async {
                      isLoading.value = true;
                      String? error = await authS.register(nameC.text, emailC.text, passC.text, 'tenant');
                      isLoading.value = false;
                      
                      if (error != null) {
                        Get.snackbar("Gagal Daftar", error, backgroundColor: Colors.red, colorText: Colors.white);
                      } else {
                        Get.back();
                        Get.snackbar("Sukses", "Akun berhasil dibuat. Silakan login.", backgroundColor: Colors.green, colorText: Colors.white);
                      }
                    },
                  )),
                  
                  const SizedBox(height: 15),
                  TextButton(onPressed: () => Get.back(), child: const Text("Sudah punya akun? Login"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}