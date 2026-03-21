import 'package:ar_chem_lab/api/models/response/login_response_dto.dart';
import 'package:ar_chem_lab/api/models/response/user_response_dto.dart';

abstract class AuthDataSource {
  Future<String> register(String username, String email, String password);
  Future<String> verifyEmail(String email, String code);
  Future<LoginResponseDto> login(String email, String password);
  Future<LoginResponseDto> refreshToken(String token);
  Future<UserResponseDto> getProfile();
}
