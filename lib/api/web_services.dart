import 'package:ar_chem_lab/api/api_endpoints.dart';
import 'package:ar_chem_lab/api/models/request/gemini_request_dto.dart';
import 'package:ar_chem_lab/api/models/response/periodic_table_response_dto.dart';
import 'package:ar_chem_lab/api/models/response/gemini_response_dto.dart';
import 'package:ar_chem_lab/api/models/response/login_response_dto.dart';
import 'package:dio/dio.dart';
import 'package:ar_chem_lab/api/models/request/verify_email_request_dto.dart';
import 'package:ar_chem_lab/api/models/request/register_request_dto.dart';
import 'package:ar_chem_lab/api/models/request/login_request_dto.dart';
import 'package:ar_chem_lab/api/models/request/refresh_token_request_dto.dart';
import 'package:ar_chem_lab/api/models/response/user_response_dto.dart';

class WebServices {
  final Dio dio;

  WebServices(this.dio);

  Future<String> register(RegisterRequestDto request) async {
    try {
      final response = await dio.post(
        ApiEndpoints.register,
        data: request.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['message'] ?? "success";
      }
      return "Registration failed";
    } catch (e) {
      rethrow;
    }
  }

  Future<String> verifyEmail(VerifyEmailRequestDto request) async {
    try {
      final response = await dio.post(
        ApiEndpoints.verifyEmail,
        data: request.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['message'] ?? "success";
      }
      return "Verification failed";
    } catch (e) {
      rethrow;
    }
  }

  Future<LoginResponseDto> login(LoginRequestDto request) async {
    try {
      final response = await dio.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );
      return LoginResponseDto.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<LoginResponseDto> refreshToken(RefreshTokenRequestDto request) async {
    try {
      final response = await dio.post(
        ApiEndpoints.refreshToken,
        data: request.toJson(),
      );
      return LoginResponseDto.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserResponseDto> getProfile() async {
    try {
      final response = await dio.get(ApiEndpoints.profile);
      return UserResponseDto.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PeriodicTableResponseDto>> getPeriodicTable() async {
    try {
      final response = await dio.get(
        "https://pubchem.ncbi.nlm.nih.gov/rest/pug/periodictable/JSON",
      );
      final data = response.data;
      final columns = List<String>.from(data["Table"]["Columns"]["Column"]);
      final rows = data["Table"]["Row"] as List;

      return rows.map((row) {
        return PeriodicTableResponseDto.fromRow(columns, row["Cell"]);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<GeminiResponseDto> sendMessage(GeminiRequestDto request) async {
    try {
      final response = await dio.post(
        ApiEndpoints.geminiChat,
        data: request.toJson(),
      );
      return GeminiResponseDto.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
