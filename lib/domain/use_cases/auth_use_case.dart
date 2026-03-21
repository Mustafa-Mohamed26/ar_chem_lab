import 'package:ar_chem_lab/api/models/response/login_response_dto.dart';
import 'package:ar_chem_lab/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthUseCase {
  final AuthRepository repository;

  AuthUseCase({required this.repository});

  Future<String> register(
    String username,
    String email,
    String password,
  ) async {
    return await repository.register(username, email, password);
  }

  Future<String> verifyEmail(String email, String code) async {
    return await repository.verifyEmail(email, code);
  }

  Future<String> forgotPassword(String email) async {
    return await repository.forgotPassword(email);
  }

  Future<String> resetPassword(
    String email,
    String code,
    String newPassword,
  ) async {
    return await repository.resetPassword(email, code, newPassword);
  }

  Future<LoginResponseDto> login(String email, String password) async {
    return await repository.login(email, password);
  }

  Future<LoginResponseDto> refreshToken(String token) async {
    return await repository.refreshToken(token);
  }
}
