import 'package:ar_chem_lab/api/models/response/login_response_dto.dart';
import 'package:ar_chem_lab/domain/entities/user.dart';

abstract class AuthRepository {
  Future<String> register(String username, String email, String password);
  Future<LoginResponseDto> login(String email, String password);
  Future<LoginResponseDto> refreshToken(String token);
  Future<User> getProfile();
}
