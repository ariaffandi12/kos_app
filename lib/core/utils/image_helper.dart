import '../constants/api_url.dart';

class ImageHelper {
  static String getRoomImageUrl(String? fileName) {
    if (fileName == null || fileName.isEmpty) return "https://picsum.photos/seed/room/200/200";
    if (fileName.startsWith("http")) return fileName;
    return "${ApiUrl.baseUrl}/uploads/rooms/$fileName";
  }
  static String getReceiptImageUrl(String? fileName) {
    if (fileName == null || fileName.isEmpty) return "";
    if (fileName.startsWith("http")) return fileName;
    return "${ApiUrl.baseUrl}/uploads/receipts/$fileName";
  }
}