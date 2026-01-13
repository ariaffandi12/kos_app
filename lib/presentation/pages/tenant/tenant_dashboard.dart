import 'package:flutter/material.dart';
import 'package:kos_app/core/constants/app_styles.dart';
import 'package:provider/provider.dart'; // WAJIB ADA untuk watch/read/Consumer
import '../../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/bill_provider.dart';
import '../../router.dart';

class TenantDashboard extends StatelessWidget {
  const TenantDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil data user yang sedang login
    final user = context.watch<AuthProvider>().user;

    // Muat data bill berdasarkan user ID (opsional dipanggil di sini)
    if (user != null) {
      context.read<BillProvider>().load(user.id);
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        title: Text("Hi, ${user?.name ?? 'Tenant'}"),
        actions: [
          Icon(Icons.notifications),
          SizedBox(width: 15)
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Kamar
            Container(
              padding: EdgeInsets.all(20),
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Room 204 • Premium", style: AppStyles.headline1),
                  SizedBox(height: 5),
                  Text("Active", style: TextStyle(color: Colors.green)),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Card Tagihan
            Consumer<BillProvider>(
              builder: (ctx, prov, _) {
                final bill = prov.bills.isNotEmpty ? prov.bills.first : null;
                if (bill == null) return SizedBox();

                return Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.payments, color: Colors.orange),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Month: ${bill.month}", style: AppStyles.bodyText),
                            Text("\$${bill.totalAmount}", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.bills),
                        child: Text("Pay"),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 20),

            // Quick Actions
            Text("Quick Actions", style: AppStyles.headline2),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.bills),
                    child: Container(
                      height: 80,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.receipt_long, color: AppColors.primary),
                            SizedBox(height: 5),
                            Text("Bill", style: AppStyles.bodyText),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.submitComplaint),
                    child: Container(
                      height: 80,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.report_problem, color: AppColors.primary),
                            SizedBox(height: 5),
                            Text("Report", style: AppStyles.bodyText),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat, color: AppColors.primary),
                            SizedBox(height: 5),
                            Text("Chat", style: AppStyles.bodyText),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: AppColors.backgroundDark,
        selectedItemColor: AppColors.primary,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, AppRoutes.bills);
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "Bills"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Set"),
        ],
      ),
    );
  }
}