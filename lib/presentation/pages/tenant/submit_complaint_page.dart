import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <--- PASTIKAN BARIS INI ADA

// Import Widget Kustom
import 'package:kos_app/presentation/widgets/custom_button.dart';
import 'package:kos_app/presentation/widgets/custom_textfield.dart';

// Import Constants & Providers
import 'package:kos_app/core/constants/app_colors.dart';
import 'package:kos_app/presentation/providers/complaint_provider.dart';
import 'package:kos_app/presentation/providers/auth_provider.dart';

class SubmitComplaintPage extends StatefulWidget {
  const SubmitComplaintPage({super.key});
  
  @override
  State<SubmitComplaintPage> createState() => _SubmitComplaintPageState();
}

class _SubmitComplaintPageState extends State<SubmitComplaintPage> {
  final TextEditingController _controller = TextEditingController();
  String _urgency = 'Normal';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submitComplaint() async {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Harap isi detail keluhan")));
      return;
    }

    final user = context.read<AuthProvider>().user;
    if (user == null) return;

    // Tampilkan loading (opsional, bisa pakai dialog)
    bool success = await context.read<ComplaintProvider>().createComplaint(
      user.id, 
      'Room 204', // Hardcode room number untuk demo
      _controller.text, 
      _urgency
    );

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Keluhan berhasil dikirim")));
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal mengirim keluhan")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text("Submit Complaint"),
        backgroundColor: AppColors.backgroundDark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomTextField(controller: _controller, hint: "Describe your issue..."),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _btn("Normal", _urgency == "Normal", () => setState(() => _urgency = "Normal"))
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _btn("Urgent", _urgency == "Urgent", () => setState(() => _urgency = "Urgent"))
                ),
              ],
            ),
            const Spacer(),
            CustomButton(
              label: "Submit", 
              onPressed: _submitComplaint
            ),
          ],
        ),
      ),
    );
  }

  Widget _btn(String t, bool s, VoidCallback f) {
    return GestureDetector(
      onTap: f,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: s ? AppColors.primary : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(child: Text(t)),
      ),
    );
  }
}