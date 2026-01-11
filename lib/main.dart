import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Import Services
import 'services/db_service.dart';
import 'services/auth_service.dart';

// Import Screens
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/owner_dashboard.dart';
import 'screens/tenant_dashboard.dart';
import 'screens/rooms.dart';
import 'screens/complains.dart';
import 'screens/chat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Database
  await DBService.instance.database;

  // Inisialisasi Notifikasi
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await FlutterLocalNotificationsPlugin().initialize(initializationSettings);

  runApp(const KosApp());
}

class KosApp extends StatelessWidget {
  const KosApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi AuthService
    final authS = Get.put(AuthService());
    
    return GetMaterialApp(
      title: 'KosManager Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins', // Pastikan font ada atau gunakan default
        useMaterial3: true,
      ),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),
        GetPage(name: '/owner-dashboard', page: () => const OwnerDashboard()),
        GetPage(name: '/tenant-dashboard', page: () => const TenantDashboard()),
        GetPage(name: '/rooms', page: () => const RoomsScreen()),
        GetPage(name: '/complaints', page: () => const ComplaintsScreen()),
        GetPage(name: '/chat', page: () => const ChatScreen()),
      ],
    );
  }
}