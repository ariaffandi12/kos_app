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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Penghuni")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameC, decoration: const InputDecoration(labelText: "Nama Lengkap")),
            const SizedBox(height: 10),
            TextField(controller: emailC, decoration: const InputDecoration(labelText: "Email")),
            const SizedBox(height: 10),
            TextField(controller: passC, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 20),
            CustomButton(
              text: "DAFTAR",
              onPressed: () async {
                await authS.register(nameC.text, emailC.text, passC.text, 'tenant');
                Get.back();
                Get.snackbar("Sukses", "Silakan login dengan akun baru");
              },
            )
          ],
        ),
      ),
    );
  }
}