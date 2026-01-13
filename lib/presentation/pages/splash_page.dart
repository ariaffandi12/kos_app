import 'package:flutter/material.dart';
import 'package:kos_app/presentation/router.dart';


class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Navigasi otomatis setelah 2 detik ke Login Page
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    });

    return Scaffold(
      backgroundColor: Color(0xFF111821), // Warna Background StayHub
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_work, color: Color(0xFF196ee6), size: 80),
            SizedBox(height: 20),
            Text("StayHub", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}