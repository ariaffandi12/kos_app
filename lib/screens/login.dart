import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kos_app/services/auth_service.dart';
import 'package:kos_app/widgets/custom_button.dart';
import 'package:kos_app/widgets/particle_background.dart';


class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailC = TextEditingController(text: 'admin@kos.com');
  final TextEditingController passC = TextEditingController(text: 'admin');
  final authS = Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ParticleBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("KosManager", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                const SizedBox(height: 10),
                const Text("Login ke akun Anda", style: TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 40),
                TextField(
                  controller: emailC,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passC,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 30),
                Obx(() => CustomButton(
                  text: "MASUK",
                  isLoading: false,
                  onPressed: () async {
                    bool success = await authS.login(emailC.text, passC.text);
                    if (success) {
                      if (authS.currentUser.value!.role == 'owner') {
                        Get.offAllNamed('/owner-dashboard');
                      } else {
                        Get.offAllNamed('/tenant-dashboard');
                      }
                    } else {
                      Get.snackbar("Error", "Email atau Password salah", backgroundColor: Colors.red, colorText: Colors.white);
                    }
                  },
                )),
                TextButton(onPressed: () => Get.toNamed('/register'), child: const Text("Belum punya akun? Daftar"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}