import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kos_app/models/bill.dart';
import 'package:kos_app/models/user.dart';
import 'package:sqflite/sqflite.dart';

import 'db_service.dart';

class BillingService extends GetxController {
  final RxList<Bill> bills = <Bill>[].obs;

  // Generate tagihan otomatis untuk semua tenant aktif
  Future<void> generateBills() async {
    final db = await DBService.instance.database;
    final users = await db.query('users', where: 'role = ?', whereArgs: ['tenant']);
    final currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());

    for (var userMap in users) {
      var user = User.fromMap(userMap);
      // Cek apakah sudah ada tagihan bulan ini
      final existing = await db.query(
        'bills',
        where: 'tenantId = ? AND month = ?',
        whereArgs: [user.id.toString(), currentMonth],
      );

      if (existing.isEmpty && user.roomId != null) {
        // Ambil harga kamar
        final rooms = await db.query(
          'rooms',
          where: 'id = ?',
          whereArgs: [int.tryParse(user.roomId!)],
        );
        double price = 0;
        if (rooms.isNotEmpty) price = rooms.first['price'] as double;

        await db.insert('bills', Bill(
          tenantId: user.id.toString(),
          month: currentMonth,
          amount: price,
          status: 'unpaid'
        ).toMap());
      }
    }
    fetchBills();
  }

  Future<void> fetchBills() async {
    final db = await DBService.instance.database;
    final result = await db.query('bills', orderBy: 'id DESC');
    bills.value = result.map((e) => Bill.fromMap(e)).toList();

    // Logic Grace Period (> 5 tanggal jadi Late)
    final day = DateTime.now().day;
    if (day > 5) {
      for (var bill in bills) {
        if (bill.status == 'unpaid') {
          await db.update('bills', {'status': 'late'}, where: 'id = ?', whereArgs: [bill.id]);
        }
      }
      fetchBills(); // Refresh
    }
  }

  Future<void> uploadProof(int billId, String imagePath) async {
    final db = await DBService.instance.database;
    await db.update(
      'bills',
      {'proofImage': imagePath, 'status': 'paid'},
      where: 'id = ?',
      whereArgs: [billId],
    );
    fetchBills();
  }
}