import 'package:ar_chem_lab/api/mapper/gemini_mapper.dart';
import 'package:ar_chem_lab/api/models/response/gemini_response_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GeminiMapper Unit Tests', () {
    test('toGeminiDto should correctly map String to GeminiRequestDto', () {
      // Arrange
      const prompt = "Explain water molecule";

      // Act
      final requestDto = prompt.toGeminiDto();

      // Assert
      expect(requestDto.contents.length, 1);
      expect(requestDto.contents.first.role, 'user');
      expect(requestDto.contents.first.parts.length, 1);
      expect(requestDto.contents.first.parts.first.text, prompt);
    });

    test('toDomain should correctly map GeminiResponseDto to AiMessage', () {
      // Arrange
      final responseDto = GeminiResponseDto(
        candidates: [
          Candidate(
            content: ContentResponse(
              parts: [PartResponse(text: "Water is H2O")]
            )
          )
        ]
      );

      // Act
      final message = responseDto.toDomain();

      // Assert
      expect(message.text, "Water is H2O");
      expect(message.isUser, isFalse);
      expect(message.time, isNotNull);
    });

    test('toDomain should return safety error message if candidates list is empty', () {
      // Arrange
      final responseDto = GeminiResponseDto(candidates: []);

      // Act
      final message = responseDto.toDomain();

      // Assert
      expect(message.text, "I'm sorry, I couldn't generate a response. Please try again.");
      expect(message.isUser, isFalse);
    });

    test('toDomain should return error parsing message if an exception occurs during mapping', () {
      // Arrange
      // Let's create a DTO that will throw a NullThrownError or NoSuchMethodError during access
      // by passing a candidate with null values inside it, causing candidates.first.content to throw
      final responseDto = GeminiResponseDto(
        candidates: [
          Candidate(
            content: ContentResponse(parts: [])
          )
        ]
      );

      // Act
      final message = responseDto.toDomain();

      // Assert
      expect(message.text.contains("Error parsing AI response:"), isTrue);
      expect(message.isUser, isFalse);
    });
  });
}
