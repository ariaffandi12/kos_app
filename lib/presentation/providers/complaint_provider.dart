import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // WAJIB
import 'package:http/http.dart' as http;
import '../../../core/constants/api_url.dart';
import '../../domain/entities/complaint.dart';

class ComplaintProvider with ChangeNotifier {
  List<ComplaintEntity> _complaints = [];
  List<ComplaintEntity> get complaints => _complaints;

  Future<void> fetch() async {
    try {
      final res = await http.get(Uri.parse('${ApiUrl.baseUrl}/complaints/get_complaints.php'));
      final list = jsonDecode(res.body) as List;
      _complaints = list.map((e) => ComplaintEntity(
        id: e['id'], tenantName: e['tenant_name'], roomNumber: e['room_number'],
        issue: e['issue'], urgency: e['urgency'], status: e['status']
      )).toList();
      notifyListeners();
    } catch(e) { print(e); }
  }

  Future<bool> createComplaint(int userId, String roomNumber, String issue, String urgency) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiUrl.baseUrl}/complaints/create_complaint.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'room_number': roomNumber, 'issue': issue, 'urgency': urgency}),
      );
      if (response.statusCode == 200) {
        fetch(); // Refresh list
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}