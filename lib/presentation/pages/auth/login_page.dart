import 'package:flutter/material.dart';
import 'package:kos_app/core/constants/app_styles.dart';
import 'package:kos_app/presentation/widgets/custom_button.dart';
import 'package:kos_app/presentation/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController(text: 'tenant@kos.com');
  final pass = TextEditingController(text: '123');
  String _role = 'Tenant';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(child: Padding(padding: EdgeInsets.all(24), child: Column(
        children: [
          SizedBox(height: 60), Icon(Icons.home_work, color: AppColors.primary, size: 40),
          Text("StayHub", style: AppStyles.headline1), SizedBox(height: 40),
          Row(children: [_rb("Tenant", _role=="Tenant"), SizedBox(width: 10), _rb("Owner", _role=="Owner")]),
          SizedBox(height: 30),
          CustomTextField(controller: email, hint: "Email"), SizedBox(height: 20),
          CustomTextField(controller: pass, hint: "Password", obscureText: true),
          Spacer(),
          Consumer<AuthProvider>(builder: (c, auth, _) => auth.isLoading ? CircularProgressIndicator() : CustomButton(label: "Log In", onPressed: () async {
            await auth.login(email.text, pass.text);
            if(auth.isLoggedIn) Navigator.pushReplacementNamed(context, _role=='Tenant' ? AppRoutes.tenantDashboard : AppRoutes.ownerDashboard);
          }))
        ],
      )))
    );
  }

  Widget _rb(String l, bool s) => Expanded(child: GestureDetector(
    onTap: ()=>setState(()=>_role=l),
    child: Container(padding: EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: s ? AppColors.primary : AppColors.surfaceDark, borderRadius: BorderRadius.circular(10)), child: Center(child: Text(l, style: TextStyle(color: s ? Colors.white : AppColors.textSecondary))))
  ));
}