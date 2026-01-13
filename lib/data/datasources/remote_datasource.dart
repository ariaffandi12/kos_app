import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_url.dart';

class RemoteDataSource {
  final http.Client client;
  RemoteDataSource({required this.client});

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await client.post(Uri.parse('${ApiUrl.baseUrl}/auth/login.php'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'email': email, 'password': password}));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') return data['data'];
      throw Exception(data['message']);
    } else { throw Exception("Server Error"); }
  }

  Future<List<dynamic>> getRooms() async {
    final response = await client.get(Uri.parse('${ApiUrl.baseUrl}/rooms/get_rooms.php'));
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception("Failed load rooms");
  }

  Future<bool> uploadProof(int billId, File imageFile) async {
    var request = http.MultipartRequest('POST', Uri.parse('${ApiUrl.baseUrl}/bills/upload_proof.php'));
    request.files.add(await http.MultipartFile.fromPath('proof_image', imageFile.path));
    request.fields['bill_id'] = billId.toString();
    var response = await request.send();
    return response.statusCode == 200;
  }

  Future<List<dynamic>> getBills(int userId) async {
    final response = await client.get(Uri.parse('${ApiUrl.baseUrl}/bills/get_bills.php?user_id=$userId'));
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception("Failed load bills");
  }

  Future<List<dynamic>> getComplaints() async {
    final response = await client.get(Uri.parse('${ApiUrl.baseUrl}/complaints/get_complaints.php'));
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception("Failed load complaints");
  }
}