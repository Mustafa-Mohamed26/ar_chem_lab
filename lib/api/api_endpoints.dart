import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static String get geminiChat =>
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent?key=${dotenv.env['GEMINI_API_KEY']}";

  static String get baseUrl => "http://192.168.1.14:8000";

  static String get register => "$baseUrl/register";
  static String get login => "$baseUrl/login";
  static String get verifyEmail => "$baseUrl/verify-email";
  static String get refreshToken => "$baseUrl/refresh";
  static String get profile => "$baseUrl/profile";
  static String get forgotPassword => "$baseUrl/forgot-password";
  static String get verifyResetCode => "$baseUrl/verify-reset-code";
  static String get resetPassword => "$baseUrl/reset-password";
}
