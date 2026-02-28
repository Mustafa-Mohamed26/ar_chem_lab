import 'package:ar_chem_lab/api/models/request/gemini_request_dto.dart';
import 'package:ar_chem_lab/api/models/response/gemini_response_dto.dart';
import 'package:ar_chem_lab/domain/entities/ai_message.dart';

extension GeminiRequestMapper on String {
  GeminiRequestDto toGeminiDto() {
    return GeminiRequestDto(
      contents: [
        Content(
          role: 'user',
          parts: [Part(text: this)],
        ),
      ],
    );
  }
}

extension GeminiResponseMapper on GeminiResponseDto {
  AiMessage toDomain() {
    try {
      if (candidates.isEmpty) {
        return AiMessage(
          text: "I'm sorry, I couldn't generate a response. Please try again.",
          isUser: false,
          time: DateTime.now(),
        );
      }

      final candidate = candidates.first;
      final text = candidate.content.parts.first.text;

      return AiMessage(text: text, isUser: false, time: DateTime.now());
    } catch (e) {
      return AiMessage(
        text: "Error parsing AI response: $e",
        isUser: false,
        time: DateTime.now(),
      );
    }
  }
}
