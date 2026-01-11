import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kos_app/screens/complains.dart';

// Import Services
import 'services/db_service.dart';
import 'services/auth_service.dart';

// Import Screens
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/owner_dashboard.dart';
import 'screens/tenant_dashboard.dart';
import 'screens/rooms.dart';

import 'screens/chat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Database
  await DBService.instance.database;

  // Inisialisasi Notifikasi
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await FlutterLocalNotificationsPlugin().initialize(initializationSettings);

  runApp(const KosApp());
}

class KosApp extends StatelessWidget {
  const KosApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Menginisialisasi AuthService agar tersedia di seluruh aplikasi
    // PERBAIKAN: Menghapus variabel 'authS' karena tidak digunakan secara langsung di sini
    Get.put(AuthService());

    return GetMaterialApp(
      title: 'KosManager Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins', 
        useMaterial3: true,
      ),
      initialRoute: '/login',
      getPages: [
        // PERBAIKAN: Menghapus kata 'const' di depan Widget karena constructornya bukan const
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(name: '/owner-dashboard', page: () => OwnerDashboard()),
        GetPage(name: '/tenant-dashboard', page: () => TenantDashboard()),
        GetPage(name: '/rooms', page: () => RoomsScreen()),
        GetPage(name: '/complaints', page: () => ComplaintsScreen()),
        GetPage(name: '/chat', page: () => ChatScreen()),
      ],
    );
  }
}