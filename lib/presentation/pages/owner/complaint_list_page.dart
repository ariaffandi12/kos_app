import 'package:flutter/material.dart';
import 'package:kos_app/presentation/widgets/custom_card.dart';
import 'package:kos_app/presentation/widgets/status_badge.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/complaint_provider.dart';

class ComplaintListPage extends StatelessWidget {
  const ComplaintListPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.backgroundDark, appBar: AppBar(title: Text("Complaints"), backgroundColor: AppColors.backgroundDark), body: Consumer<ComplaintProvider>(builder: (_, prov, __) {
      if(prov.complaints.isEmpty) prov.fetch();
      return ListView.builder(itemCount: prov.complaints.length, itemBuilder: (_, i) {
        final c = prov.complaints[i];
        return CustomCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(c.tenantName, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Chip(label: Text(c.urgency), backgroundColor: c.urgency=='Urgent'?Colors.red:Colors.blue, labelStyle: TextStyle(color: Colors.white, fontSize: 10))]),
          SizedBox(height: 5), Text(c.issue, style: TextStyle(color: Colors.grey)),
          SizedBox(height: 10), StatusBadge(status: c.status)
        ]));
      });
    }));
  }
}