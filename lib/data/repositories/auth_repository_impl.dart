import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote_datasource.dart';
import '../models/user_model.dart';
class AuthRepositoryImpl implements AuthRepository {
  final RemoteDataSource remoteDataSource;
  AuthRepositoryImpl({required this.remoteDataSource});
  @override
  Future<UserEntity> login(String email, String password) async {
    final remoteData = await remoteDataSource.login(email, password);
    return UserModel.fromJson(remoteData).toEntity();
  }
}