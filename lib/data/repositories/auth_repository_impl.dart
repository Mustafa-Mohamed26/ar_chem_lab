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
  Future<String> login(String username, String password) async {
    return await remoteDataSource.login(username, password);
  }
}
