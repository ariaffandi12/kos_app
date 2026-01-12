import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Import Services
import 'services/db_service.dart';
import 'services/auth_service.dart';

// Import Screens
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/owner_dashboard.dart';
import 'screens/tenant_dashboard.dart';
import 'screens/rooms.dart';
import 'screens/billing.dart';
import 'screens/complains.dart';
import 'screens/chat.dart';
import 'screens/announcement.dart';

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
    Get.put(AuthService());
    
    return GetMaterialApp(
      title: 'KosManager Pro',
      debugShowCheckedModeBanner: false,
      
      // THEME KONFIGURASI (Material Design 3)
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        fontFamily: 'Poppins',
        
        // Menggunakan CardThemeData (Const ini aman)
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        ),
        
        // PERBAIKAN: Hapus 'const' dari AppBarTheme.
        // Ini menyelesaikan error pada IconThemeData dan TextStyle di dalamnya.
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          iconTheme: const IconThemeData(color: Colors.black87, size: 22),
          titleTextStyle: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(name: '/owner-dashboard', page: () => OwnerDashboard()),
        GetPage(name: '/tenant-dashboard', page: () => TenantDashboard()),
        GetPage(name: '/rooms', page: () => RoomsScreen()),
        GetPage(name: '/billing', page: () => BillingDetailScreen(isAdmin: false)),
        GetPage(name: '/complains', page: () => ComplainsScreen()),
        GetPage(name: '/chat', page: () => ChatScreen()),
        GetPage(name: '/announcement', page: () => AnnouncementScreen()),
      ],
    );
  }
}