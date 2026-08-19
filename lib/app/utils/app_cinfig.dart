import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  static String get geminiModel =>
      dotenv.env['GEMINI_MODEL'] ?? 'gemini-3.5-flash-lite';
}
