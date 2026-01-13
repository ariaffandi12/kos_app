import '../entities/bill.dart';
import '../repositories/bill_repository.dart';
class GetBills {
  final BillRepository repository;
  GetBills(this.repository);
  Future<List<BillEntity>> call(int userId) => repository.getBills(userId);
}