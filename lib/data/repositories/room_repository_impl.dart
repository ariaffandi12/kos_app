import '../../domain/entities/room.dart';
import '../../domain/repositories/room_repository.dart';
import '../datasources/remote_datasource.dart';
import '../models/room_model.dart';
class RoomRepositoryImpl implements RoomRepository {
  final RemoteDataSource remoteDataSource;
  RoomRepositoryImpl({required this.remoteDataSource});
  @override
  Future<List<RoomEntity>> getRooms() async {
    final remoteData = await remoteDataSource.getRooms();
    return remoteData.map((e) => RoomModel.fromJson(e).toEntity()).toList();
  }
}