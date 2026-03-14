import 'package:ar_chem_lab/api/models/response/login_response_dto.dart';
import 'package:ar_chem_lab/data/data_sources/remote/auth_data_source.dart';
import 'package:ar_chem_lab/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> register(String username, String email, String password) async {
    return await remoteDataSource.register(username, email, password);
  }

  @override
  Future<LoginResponseDto> login(String username, String password) async {
    return await remoteDataSource.login(username, password);
  }

  @override
  Future<LoginResponseDto> refreshToken(String token) async {
    return await remoteDataSource.refreshToken(token);
  }
}
