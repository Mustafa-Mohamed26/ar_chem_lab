import 'package:ar_chem_lab/api/models/response/login_response_dto.dart';
import 'package:ar_chem_lab/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthUseCase {
  final AuthRepository repository;

  AuthUseCase({required this.repository});

  Future<String> register(String username, String email, String password) async {
    return await repository.register(username, email, password);
  }

  Future<LoginResponseDto> login(String username, String password) async {
    return await repository.login(username, password);
  }

  Future<LoginResponseDto> refreshToken(String token) async {
    return await repository.refreshToken(token);
  }
}
