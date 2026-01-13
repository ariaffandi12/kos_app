import 'dart:io';
import '../../domain/entities/bill.dart';
import '../../domain/repositories/bill_repository.dart';
import '../datasources/remote_datasource.dart';
import '../models/bill_model.dart';
class BillRepositoryImpl implements BillRepository {
  final RemoteDataSource remoteDataSource;
  BillRepositoryImpl({required this.remoteDataSource});
  @override
  Future<bool> uploadProof(int billId, File imageFile) async => await remoteDataSource.uploadProof(billId, imageFile);
  @override
  Future<List<BillEntity>> getBills(int userId) async {
    final remoteData = await remoteDataSource.getBills(userId);
    return remoteData.map((e) => BillModel.fromJson(e).toEntity()).toList();
  }
}