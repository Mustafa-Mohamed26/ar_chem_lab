import 'package:ar_chem_lab/api/models/response/login_response_dto.dart';

abstract class AuthDataSource {
  Future<String> register(String username, String email, String password);
  Future<LoginResponseDto> login(String username, String password);
  Future<LoginResponseDto> refreshToken(String token);
}
