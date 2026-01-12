import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/particle_background.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  final authS = Get.find<AuthService>();
  final RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ParticleBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Ikon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.deepPurple.withOpacity(0.2), blurRadius: 20, spreadRadius: 5)
                    ],
                  ),
                  child: const Icon(Icons.home_work, size: 50, color: Colors.deepPurple),
                ),
                const SizedBox(height: 30),
                
                // Judul
                const Text(
                  "Selamat Datang",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                ),
                const SizedBox(height: 8),
                Text(
                  "Silakan masuk ke akun Anda",
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 40),
                
                // Kartu Form Login
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 0)],
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailC,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                          filled: true,
                          fillColor: Color(0xFFF3F4F6),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passC,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                          filled: true,
                          fillColor: Color(0xFFF3F4F6),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Obx(() => SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: "MASUK",
                          isLoading: isLoading.value,
                          onPressed: () async {
                            if (emailC.text.isEmpty || passC.text.isEmpty) {
                              Get.snackbar("Peringatan", "Email dan Password tidak boleh kosong", backgroundColor: Colors.orange, colorText: Colors.white);
                              return;
                            }
                            isLoading.value = true;
                            bool success = await authS.login(emailC.text, passC.text);
                            if (success) {
                              if (authS.currentUser.value!.role == 'owner') {
                                Get.offAllNamed('/owner-dashboard');
                              } else {
                                Get.offAllNamed('/tenant-dashboard');
                              }
                            } else {
                              Get.snackbar("Gagal", "Email atau Password salah", backgroundColor: Colors.red, colorText: Colors.white);
                              isLoading.value = false;
                            }
                          },
                        ),
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                TextButton(onPressed: () => Get.toNamed('/register'), child: const Text("Belum punya akun? Daftar Sekarang"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}