import 'package:ar_chem_lab/api/data_sources/remote/ai_data_source_impl.dart';
import 'package:ar_chem_lab/api/models/request/gemini_request_dto.dart';
import 'package:ar_chem_lab/api/models/response/gemini_response_dto.dart';
import 'package:ar_chem_lab/api/web_services.dart';
import 'package:ar_chem_lab/core/exceptions/app_exceptions.dart';
import 'package:ar_chem_lab/domain/entities/ai_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWebServices extends Mock implements WebServices {}

class FakeGeminiRequestDto extends Fake implements GeminiRequestDto {}

void main() {
  late AiDataSourceImpl dataSource;
  late MockWebServices mockWebServices;

  setUpAll(() {
    registerFallbackValue(FakeGeminiRequestDto());
  });

  setUp(() {
    mockWebServices = MockWebServices();
    dataSource = AiDataSourceImpl(webServices: mockWebServices);
  });

  group('AiDataSourceImpl Unit Tests', () {
    test('sendMessage should return AiMessage on success', () async {
      // Arrange
      final responseDto = GeminiResponseDto(
        candidates: [
          Candidate(
            content: ContentResponse(
              parts: [PartResponse(text: "Hello from AI!")]
            )
          )
        ]
      );

      when(() => mockWebServices.sendMessage(any())).thenAnswer((_) async => responseDto);

      // Act
      final result = await dataSource.sendMessage("Hello");

      // Assert
      expect(result, isA<AiMessage>());
      expect(result.text, "Hello from AI!");
      expect(result.isUser, isFalse);
      verify(() => mockWebServices.sendMessage(any())).called(1);
    });

    test('sendMessage should throw AppExceptions directly if DioException contains it', () async {
      // Arrange
      final appException = ServerException(message: "Custom DB Error");
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        error: appException,
      );

      when(() => mockWebServices.sendMessage(any())).thenThrow(dioException);

      // Act & Assert
      expect(
        () => dataSource.sendMessage("Hello"),
        throwsA(isA<ServerException>().having((e) => e.message, 'message', "Custom DB Error")),
      );
    });

    test('sendMessage should map DioException to ServerException if it does not contain AppExceptions', () async {
      // Arrange
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        message: "Connection timed out",
      );

      when(() => mockWebServices.sendMessage(any())).thenThrow(dioException);

      // Act & Assert
      expect(
        () => dataSource.sendMessage("Hello"),
        throwsA(isA<ServerException>().having((e) => e.message, 'message', "Connection timed out")),
      );
    });

    test('sendMessage should wrap unexpected errors in UnexpectedException', () async {
      // Arrange
      final genericException = Exception("Something went wrong");

      when(() => mockWebServices.sendMessage(any())).thenThrow(genericException);

      // Act & Assert
      expect(
        () => dataSource.sendMessage("Hello"),
        throwsA(isA<UnexpectedException>().having((e) => e.message, 'message', contains("Exception: Something went wrong"))),
      );
    });
  });
}
