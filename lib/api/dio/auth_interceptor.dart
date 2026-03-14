import 'package:ar_chem_lab/api/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final PrettyDioLogger _logger;

  AuthInterceptor(this._dio, this._logger);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 1. Get access token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    // 2. If token exists, add it to headers
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 3. Handle 401 Unauthorized
    if (err.response?.statusCode == 401) {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refresh_token');

      if (refreshToken != null) {
        try {
          // 4. Try refreshing the token using a separate Dio instance to avoid infinite loops
          final refreshDio = Dio();
          refreshDio.interceptors.add(_logger);
          
          final response = await refreshDio.post(
            ApiEndpoints.refreshToken,
            data: {'refresh_token': refreshToken},
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            final newAccessToken = response.data['access_token'];
            final newRefreshToken = response.data['refresh_token'];

            // 5. Store new tokens
            await prefs.setString('access_token', newAccessToken);
            if (newRefreshToken != null) {
              await prefs.setString('refresh_token', newRefreshToken);
            }

            // 6. Retry the original request with the new token
            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newAccessToken';
            
            final retryResponse = await _dio.fetch(options);
            return handler.resolve(retryResponse);
          }
        } catch (e) {
          // Refresh failed, clear tokens and let the error propagate
          await prefs.remove('access_token');
          await prefs.remove('refresh_token');
        }
      }
    }

    return handler.next(err);
  }
}
