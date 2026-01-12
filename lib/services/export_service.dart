import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:file_saver/file_saver.dart';
import '../models/bill.dart';

class ExportService {
  static Future<void> exportBillsToPDF(List<Bill> bills, String userName) async {
    // Menggunakan Document dari package pdf
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
      build: (pw.Context context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Header(level: 0, text: 'Laporan Tagihan - $userName'),
          pw.SizedBox(height: 20),
          // PERBAIKAN: Menggunakan TableHelper.fromTextArray
          pw.TableHelper.fromTextArray(
            context: context,
            data: <List<String>>[
              ['Bulan', 'Jumlah (Rp)', 'Status'],
              ...bills.map((bill) => [
                bill.month,
                bill.amount.toString(),
                bill.status.toUpperCase()
              ]),
            ],
          ),
        ],
      ),
    ));

    final bytes = await pdf.save();
    

    await FileSaver.instance.saveFile(
      name: "Laporan_Tagihan_$userName.pdf",
      bytes: bytes,
      mimeType: MimeType.pdf,
    );
  }
}