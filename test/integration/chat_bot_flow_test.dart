import 'dart:async';
import 'package:ar_chem_lab/domain/entities/ai_message.dart';
import 'package:ar_chem_lab/domain/entities/user.dart';
import 'package:ar_chem_lab/presentation/auth/cubit/auth_states.dart';
import 'package:ar_chem_lab/presentation/auth/cubit/auth_view_model.dart';
import 'package:ar_chem_lab/presentation/chat_bot/chat_bot_screen.dart';
import 'package:ar_chem_lab/presentation/chat_bot/cubit/chat_cubit.dart';
import 'package:ar_chem_lab/presentation/chat_bot/cubit/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthViewModel extends Mock implements AuthViewModel {
  final _stateController = StreamController<AuthState>.broadcast();
  AuthState _state = AuthInitial();

  void emit(AuthState state) {
    _state = state;
    _stateController.add(state);
  }

  @override
  AuthState get state => _state;

  @override
  Stream<AuthState> get stream => _stateController.stream;

  @override
  Future<void> getProfile() async {}

  @override
  Future<void> close() async {
    await _stateController.close();
  }
}

class MockChatCubit extends Mock implements ChatCubit {
  final _stateController = StreamController<ChatState>.broadcast();
  ChatState _state = ChatInitial();
  final List<String> sentMessages = [];

  void emit(ChatState state) {
    _state = state;
    _stateController.add(state);
  }

  @override
  ChatState get state => _state;

  @override
  Stream<ChatState> get stream => _stateController.stream;

  @override
  Future<void> sendMessage(String text) async {
    sentMessages.add(text);
  }

  @override
  Future<void> close() async {
    await _stateController.close();
  }
}

Widget buildChatTestableWidget({
  required Widget child,
  required MockAuthViewModel authViewModel,
  required MockChatCubit chatCubit,
}) {
  return ScreenUtilInit(
    designSize: const Size(360, 690),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, _) {
      return MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<AuthViewModel>.value(value: authViewModel),
            BlocProvider<ChatCubit>.value(value: chatCubit),
          ],
          child: Scaffold(body: child),
        ),
      );
    },
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthViewModel mockAuthViewModel;
  late MockChatCubit mockChatCubit;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockAuthViewModel = MockAuthViewModel();
    mockChatCubit = MockChatCubit();
  });

  tearDown(() async {
    await mockAuthViewModel.close();
    await mockChatCubit.close();
  });

  group('Chat Bot Flow Integration Tests', () {
    testWidgets('Renders empty chatbot screen layout with initial cards', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      // Emit profile success
      mockAuthViewModel.emit(ProfileSuccess(User(
        id: 1,
        username: "Mustafa",
        hashedPassword: "",
      )));
      mockChatCubit.emit(ChatInitial());

      await tester.pumpWidget(buildChatTestableWidget(
        child: const ChatBotScreen(),
        authViewModel: mockAuthViewModel,
        chatCubit: mockChatCubit,
      ));
      await tester.pumpAndSettle();

      // Check header and greeting
      expect(find.text("HEY MUSTAFA"), findsOneWidget);
      expect(find.text("Hello MUSTAFA"), findsOneWidget);
      expect(find.text("How can i assist you today?"), findsOneWidget);
      
      // Feature cards should be present
      expect(find.textContaining("Generate Chemical Solutions"), findsOneWidget);
    });

    testWidgets('Typing and pressing send triggers Cubit message sending', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      mockAuthViewModel.emit(AuthInitial());
      mockChatCubit.emit(ChatInitial());

      await tester.pumpWidget(buildChatTestableWidget(
        child: const ChatBotScreen(),
        authViewModel: mockAuthViewModel,
        chatCubit: mockChatCubit,
      ));
      await tester.pumpAndSettle();

      // Enter prompt
      final inputFinder = find.byType(TextField);
      expect(inputFinder, findsOneWidget);
      await tester.enterText(inputFinder, "Explain H2O molecular structure");
      await tester.pumpAndSettle();

      // Send message
      // On line 322 the icon is Icons.add inside the gesture detector. Or we can tap the Icon directly.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(mockChatCubit.sentMessages, ["Explain H2O molecular structure"]);
    });

    testWidgets('Displays message thread correctly when states contain messages', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      mockAuthViewModel.emit(AuthInitial());
      
      final messages = [
        AiMessage(text: "What is H2O?", isUser: true, time: DateTime.now()),
        AiMessage(text: "H2O is water, composed of two hydrogen atoms and one oxygen atom.", isUser: false, time: DateTime.now()),
      ];
      mockChatCubit.emit(ChatSuccess(messages));

      await tester.pumpWidget(buildChatTestableWidget(
        child: const ChatBotScreen(),
        authViewModel: mockAuthViewModel,
        chatCubit: mockChatCubit,
      ));
      await tester.pumpAndSettle();

      // Assert both messages are visible
      expect(find.text("What is H2O?"), findsOneWidget);
      expect(find.textContaining("H2O is water, composed of"), findsOneWidget);
    });
  });
}
