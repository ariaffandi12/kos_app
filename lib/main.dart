import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'core/theme.dart';
import 'data/datasources/remote_datasource.dart';

// Domain
import 'domain/usecases/login_user.dart';
import 'domain/usecases/get_rooms.dart';
import 'domain/usecases/upload_bill_proof.dart';
import 'domain/usecases/get_bills.dart';

// Repositories
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/room_repository_impl.dart';
import 'data/repositories/bill_repository_impl.dart';

// Presentation - Providers
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/room_provider.dart';
import 'presentation/providers/bill_provider.dart';
import 'presentation/providers/complaint_provider.dart';

// Presentation - Pages
import 'presentation/pages/splash_page.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/auth/register_page.dart';

// Pastikan import ini menggunakan path relatif yang benar
import 'presentation/pages/owner/owner_dashboard.dart';
import 'presentation/pages/owner/room_management_page.dart'; 
import 'presentation/pages/owner/complaint_list_page.dart';

import 'presentation/pages/tenant/tenant_dashboard.dart';
import 'presentation/pages/tenant/monthly_bill_page.dart';
import 'presentation/pages/tenant/submit_complaint_page.dart';

import 'presentation/router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // --- DEPENDENCY INJECTION (Wiring) ---
    final remoteDataSource = RemoteDataSource(client: http.Client());
    
    final authRepo = AuthRepositoryImpl(remoteDataSource: remoteDataSource);
    final roomRepo = RoomRepositoryImpl(remoteDataSource: remoteDataSource);
    final billRepo = BillRepositoryImpl(remoteDataSource: remoteDataSource);

    final loginUserUseCase = LoginUser(authRepo);
    final getRoomsUseCase = GetRooms(roomRepo);
    final uploadProofUseCase = UploadBillProof(billRepo);
    final getBillsUseCase = GetBills(billRepo);

    return MultiProvider(
      providers: [
        // Auth Provider
        ChangeNotifierProvider(
          create: (_) => AuthProvider(loginUser: loginUserUseCase),
        ),
        // Room Provider
        ChangeNotifierProvider(
          create: (_) => RoomProvider(getRooms: getRoomsUseCase),
        ),
        // Bill Provider
        ChangeNotifierProvider(
          create: (_) => BillProvider(
            uploadProof: uploadProofUseCase,
            getBills: getBillsUseCase,
          ),
        ),
        // Complaint Provider
        ChangeNotifierProvider(
          create: (_) => ComplaintProvider()..fetch(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        initialRoute: AppRoutes.splash,
        routes: {
          // Auth Routes
          AppRoutes.splash: (ctx) => SplashPage(),
          AppRoutes.login: (ctx) => LoginPage(),
          AppRoutes.register: (ctx) => RegisterPage(),

          // Owner Routes
          AppRoutes.ownerDashboard: (ctx) => OwnerDashboard(),
          AppRoutes.roomManagement: (ctx) => RoomManagementPage(), // Sekarang ini terbaca
          AppRoutes.complaints: (ctx) => ComplaintListPage(),

          // Tenant Routes
          AppRoutes.tenantDashboard: (ctx) => TenantDashboard(),
          AppRoutes.bills: (ctx) => MonthlyBillPage(),
          AppRoutes.submitComplaint: (ctx) => SubmitComplaintPage(),
        },
      ),
    );
  }
}