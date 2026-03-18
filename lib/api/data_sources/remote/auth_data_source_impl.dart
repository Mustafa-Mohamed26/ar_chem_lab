import 'package:ar_chem_lab/api/web_services.dart';
import 'package:ar_chem_lab/api/models/request/register_request_dto.dart';
import 'package:ar_chem_lab/api/models/request/login_request_dto.dart';
import 'package:ar_chem_lab/api/models/request/refresh_token_request_dto.dart';
import 'package:ar_chem_lab/api/models/response/login_response_dto.dart';
import 'package:ar_chem_lab/api/models/response/user_response_dto.dart';
import 'package:ar_chem_lab/core/exceptions/app_exceptions.dart';
import 'package:ar_chem_lab/data/data_sources/remote/auth_data_source.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthDataSource)
class AuthDataSourceImpl implements AuthDataSource {
  final WebServices webServices;

  AuthDataSourceImpl({required this.webServices});

  @override
  Future<String> register(String username, String email, String password) async {
    try {
      final request = RegisterRequestDto(
        username: username,
        email: email,
        password: password,
      );
      return await webServices.register(request);
    } on DioException catch (e) {
      String message = "Server Error";
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map) {
          message = data['detail']?.toString() ?? data.toString();
        } else {
          message = data.toString();
        }
      } else if (e.error is AppExceptions) {
        message = (e.error as AppExceptions).message;
      } else if (e.message != null) {
        message = e.message!;
      }
      throw ServerException(message: message);
    } catch (e) {
      throw UnexpectedException(message: e.toString());
    }
  }

  @override
  Future<LoginResponseDto> login(String email, String password) async {
    try {
      final request = LoginRequestDto(
        email: email,
        password: password,
      );
      return await webServices.login(request);
    } on DioException catch (e) {
      String message = "Server Error";
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map) {
          message = data['detail']?.toString() ?? data.toString();
        } else {
          message = data.toString();
        }
      } else if (e.error is AppExceptions) {
        message = (e.error as AppExceptions).message;
      } else if (e.message != null) {
        message = e.message!;
      }
      throw ServerException(message: message);
    } catch (e) {
      throw UnexpectedException(message: e.toString());
    }
  }

  @override
  Future<LoginResponseDto> refreshToken(String token) async {
    try {
      final request = RefreshTokenRequestDto(refreshToken: token);
      return await webServices.refreshToken(request);
    } on DioException catch (e) {
      String message = "Server Error";
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map) {
          message = data['detail']?.toString() ?? data.toString();
        } else {
          message = data.toString();
        }
      } else if (e.error is AppExceptions) {
        message = (e.error as AppExceptions).message;
      } else if (e.message != null) {
        message = e.message!;
      }
      throw ServerException(message: message);
    } catch (e) {
      throw UnexpectedException(message: e.toString());
    }
  }

  @override
  Future<UserResponseDto> getProfile() async {
    try {
      return await webServices.getProfile();
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? "Failed to fetch profile",
        statusCode: e.response?.statusCode,
      );
    }
  }
}
