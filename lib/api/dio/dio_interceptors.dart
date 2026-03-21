import 'package:ar_chem_lab/core/exceptions/app_exceptions.dart';
import 'package:dio/dio.dart';

class DioInterceptors extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppExceptions exception;

    final responseData = err.response?.data;
    String message = "Something went wrong";

    if (responseData is Map) {
      final error = responseData['error'];
      if (error != null) {
        message =
            (error['message'] as String?) ??
            (error['status'] as String?) ??
            "Error Code: ${error['code']}";
      } else {
        final detail = responseData['detail'];
        if (detail is String) {
          message = detail;
        } else if (detail is List && detail.isNotEmpty) {
          message = detail[0]['msg'] as String? ?? message;
        } else {
          message =
              (responseData['errors']?['msg'] as String?) ??
              (responseData['message'] as String?) ??
              message;
        }
      }
    }

    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout) {
      exception = NetworkException(message: 'No internet connection');
    } else if (err.response?.statusCode != null) {
      final statusCode = err.response?.statusCode;
      
      switch (statusCode) {
        case 400:
          exception = BadRequestException(message: message, statusCode: statusCode);
          break;
        case 401:
          exception = UnauthorizedException(message: message, statusCode: statusCode);
          break;
        case 403:
          exception = ForbiddenException(message: message, statusCode: statusCode);
          break;
        case 404:
          exception = NotFoundException(message: message, statusCode: statusCode);
          break;
        case 500:
          exception = InternalServerException(message: message, statusCode: statusCode);
          break;
        default:
          exception = ServerException(message: message, statusCode: statusCode);
      }
    } else {
      exception = UnexpectedException(message: message);
    }

    handler.reject(
      DioException(requestOptions: err.requestOptions, error: exception),
    );
  }
}
