class ApiUrl {
  // Gunakan IP ini agar bisa diakses dari HP fisik di jaringan WiFi yang sama
  static const String baseUrl = "http://192.168.0.129/kos_app_api";
  
  static const String getRooms = "$baseUrl/rooms/get_rooms.php";
  static const String getComplaints = "$baseUrl/complaints/get_complaints.php";
}