import 'package:ar_chem_lab/api/web_services.dart';
import 'package:ar_chem_lab/api/models/request/user_request_dto.dart';
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
      final request = UserRequestDto(
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
}
