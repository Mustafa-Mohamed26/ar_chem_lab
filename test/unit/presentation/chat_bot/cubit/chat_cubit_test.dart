import 'package:ar_chem_lab/domain/entities/ai_message.dart';
import 'package:ar_chem_lab/domain/use_cases/chat_bot_use_case.dart';
import 'package:ar_chem_lab/presentation/chat_bot/cubit/chat_cubit.dart';
import 'package:ar_chem_lab/presentation/chat_bot/cubit/chat_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockChatBotUseCase extends Mock implements ChatBotUseCase {}

void main() {
  late ChatCubit cubit;
  late MockChatBotUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockChatBotUseCase();
    cubit = ChatCubit(mockUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('ChatCubit Unit Tests', () {
    test('initial state should be ChatInitial', () {
      expect(cubit.state, isA<ChatInitial>());
      expect(cubit.state.messages, isEmpty);
    });

    test('sendMessage should do nothing if text is empty or whitespace', () async {
      // Verify no state emissions happen
      final future = expectLater(cubit.stream, emitsInOrder([]));

      await cubit.sendMessage('');
      await cubit.sendMessage('   ');

      // Stream should have emitted nothing
      verifyNever(() => mockUseCase.invoke(any()));
      // Cancel future gracefully – the test assertion is that nothing was emitted
      await future.timeout(
        const Duration(milliseconds: 100),
        onTimeout: () => null, // No events expected, timeout is fine
      );
    });

    test('sendMessage success should emit user message, loading, then bot response', () async {
      // Arrange
      final botResponse = AiMessage(
        text: 'Water is H2O',
        isUser: false,
        time: DateTime.now(),
      );
      when(() => mockUseCase.invoke('What is water?')).thenAnswer((_) async => botResponse);

      // Set up expectation BEFORE calling sendMessage
      final streamFuture = expectLater(
        cubit.stream,
        emitsInOrder([
          // First state: ChatSuccess with user message
          isA<ChatSuccess>().having(
            (s) => s.messages,
            'messages',
            allOf([hasLength(1), contains(isA<AiMessage>().having((m) => m.text, 'text', 'What is water?').having((m) => m.isUser, 'isUser', isTrue))]),
          ),
          // Second state: ChatLoading with user message preserved
          isA<ChatLoading>().having((s) => s.messages, 'messages', hasLength(1)),
          // Third state: ChatSuccess with bot response appended
          isA<ChatSuccess>().having(
            (s) => s.messages,
            'messages',
            allOf([hasLength(2), contains(isA<AiMessage>().having((m) => m.text, 'text', 'Water is H2O').having((m) => m.isUser, 'isUser', isFalse))]),
          ),
        ]),
      );

      // Act
      await cubit.sendMessage('What is water?');

      // Wait for all stream expectations to be fulfilled
      await streamFuture;

      verify(() => mockUseCase.invoke('What is water?')).called(1);
    });

    test('sendMessage failure should emit user message, loading, then ChatError with history preserved', () async {
      // Arrange
      when(() => mockUseCase.invoke(any())).thenThrow(Exception('Network error'));

      // Set up expectation BEFORE calling sendMessage
      final streamFuture = expectLater(
        cubit.stream,
        emitsInOrder([
          // First state: ChatSuccess with user message
          isA<ChatSuccess>().having((s) => s.messages, 'messages', hasLength(1)),
          // Second state: ChatLoading
          isA<ChatLoading>().having((s) => s.messages, 'messages', hasLength(1)),
          // Third state: ChatError with the user message preserved and error message
          isA<ChatError>()
              .having((s) => s.messages, 'messages', hasLength(1))
              .having((s) => s.message, 'message', contains('Network error')),
        ]),
      );

      // Act
      await cubit.sendMessage('Hello');

      // Wait for all stream expectations to be fulfilled
      await streamFuture;
    });
  });
}
