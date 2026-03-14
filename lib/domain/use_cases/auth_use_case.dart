import 'package:ar_chem_lab/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthUseCase {
  final AuthRepository repository;

  AuthUseCase({required this.repository});

  Future<String> register(String username, String email, String password) async {
    return await repository.register(username, email, password);
  }

  Future<String> login(String username, String password) async {
    return await repository.login(username, password);
  }
}
