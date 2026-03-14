import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static String get geminiChat =>
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent?key=${dotenv.env['GEMINI_API_KEY']}";

  static String get register => "http://10.0.2.2:8000/register";
  static String get login => "http://10.0.2.2:8000/login";
  static String get refreshToken => "http://10.0.2.2:8000/refresh";
  static String get profile => "http://10.0.2.2:8000/profile";
  static String get forgotPassword => "http://10.0.2.2:8000/forgot-password";
  static String get verifyResetCode => "http://10.0.2.2:8000/verify-reset-code";
  static String get resetPassword => "http://10.0.2.2:8000/reset-password";
}