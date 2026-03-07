import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static String get geminiChat =>
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent?key=${dotenv.env['GEMINI_API_KEY']}";
}
