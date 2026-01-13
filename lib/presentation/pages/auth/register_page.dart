import 'package:flutter/material.dart';
import 'package:kos_app/presentation/widgets/custom_button.dart';
import 'package:kos_app/presentation/widgets/custom_textfield.dart';
import '../../../core/constants/app_colors.dart';
// Removed unused import
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();
  String _role = 'Tenant';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(title: Text("Register"), backgroundColor: AppColors.backgroundDark),
      body: Padding(padding: EdgeInsets.all(24), child: Column(
        children: [
          CustomTextField(controller: name, hint: "Name"), SizedBox(height:20),
          CustomTextField(controller: email, hint: "Email"), SizedBox(height:20),
          CustomTextField(controller: pass, hint: "Password", obscureText: true), SizedBox(height:20),
          Row(children: [_rb("Tenant", _role=="Tenant"), SizedBox(width:10), _rb("Owner", _role=="Owner")]),
          Spacer(),
          CustomButton(label: "Register", onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginPage())))
        ],
      ))
    );
  }
  Widget _rb(String l, bool s) => Expanded(child: GestureDetector(
    onTap: ()=>setState(()=>_role=l),
    child: Container(padding: EdgeInsets.symmetric(vertical:12), decoration: BoxDecoration(color: s ? AppColors.primary : AppColors.surfaceDark, borderRadius: BorderRadius.circular(10)), child: Center(child: Text(l, style: TextStyle(color: s ? Colors.white : AppColors.textSecondary))))
  ));
}