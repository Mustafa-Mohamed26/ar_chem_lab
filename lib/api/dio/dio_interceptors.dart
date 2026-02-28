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
        message =
            (responseData['errors']?['msg'] as String?) ??
            (responseData['message'] as String?) ??
            message;
      }
    }

    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout) {
      exception = NetworkException(message: 'No internet connection');
    } else if (err.response?.statusCode != null) {
      message = "[$message] (Status: ${err.response?.statusCode})";
      exception = ServerException(
        message: message,
        statusCode: err.response?.statusCode,
      );
    } else {
      exception = UnexpectedException(message: message);
    }

    handler.reject(
      DioException(requestOptions: err.requestOptions, error: exception),
    );
  }
}
