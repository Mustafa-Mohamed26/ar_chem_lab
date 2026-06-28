import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static String get geminiChat =>
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent?key=${dotenv.env['GEMINI_API_KEY']}";

  static String get baseUrl => "https://ungermane-nondeafly-dorinda.ngrok-free.dev";

  static String get register => "$baseUrl/auth/register";
  static String get login => "$baseUrl/auth/login";
  static String get verifyEmail => "$baseUrl/auth/verify-email";
  static String get refreshToken => "$baseUrl/auth/refresh";
  static String get profile => "$baseUrl/auth/user-data";
  static String get forgotPassword => "$baseUrl/auth/forgot-password";
  static String get resetPassword => "$baseUrl/reset-password";
}
