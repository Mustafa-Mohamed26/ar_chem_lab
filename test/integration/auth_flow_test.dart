import 'dart:async';
import 'package:ar_chem_lab/presentation/widget/app_button.dart';
import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/presentation/auth/cubit/auth_states.dart';
import 'package:ar_chem_lab/presentation/auth/cubit/auth_view_model.dart';
import 'package:ar_chem_lab/presentation/auth/email_verification_screen.dart';
import 'package:ar_chem_lab/presentation/auth/forgot_password_screen.dart';
import 'package:ar_chem_lab/presentation/auth/login_screen.dart';
import 'package:ar_chem_lab/presentation/auth/register_screen.dart';
import 'package:ar_chem_lab/presentation/auth/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthViewModel extends Mock implements AuthViewModel {
  @override
  final nameController = TextEditingController();
  @override
  final emailController = TextEditingController();
  @override
  final passwordController = TextEditingController();
  @override
  final confirmPasswordController = TextEditingController();

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
  Future<void> close() async {
    await _stateController.close();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}

Widget buildAuthTestableWidget(Widget child, MockAuthViewModel mockViewModel) {
  return ScreenUtilInit(
    designSize: const Size(360, 690),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, _) {
      return MaterialApp(
        routes: {
          AppRoutes.welcomeScreen: (context) => const WelcomeScreen(),
          AppRoutes.loginScreen: (context) => BlocProvider<AuthViewModel>.value(
                value: mockViewModel,
                child: const LoginScreen(),
              ),
          AppRoutes.registerScreen: (context) => BlocProvider<AuthViewModel>.value(
                value: mockViewModel,
                child: const RegisterScreen(),
              ),
          AppRoutes.homeScreen: (context) => const Scaffold(body: Text("Home Screen")),
          AppRoutes.forgotPasswordScreen: (context) => BlocProvider<AuthViewModel>.value(
                value: mockViewModel,
                child: const ForgotPasswordScreen(),
              ),
          AppRoutes.emailVerificationScreen: (context) => BlocProvider<AuthViewModel>.value(
                value: mockViewModel,
                child: const EmailVerificationScreen(),
              ),
        },
        home: BlocProvider<AuthViewModel>.value(
          value: mockViewModel,
          child: child,
        ),
      );
    },
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthViewModel mockViewModel;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockViewModel = MockAuthViewModel();
    // Default mock methods
    when(() => mockViewModel.login(rememberMe: any(named: "rememberMe"))).thenAnswer((_) async {});
    when(() => mockViewModel.register()).thenAnswer((_) async {});
    when(() => mockViewModel.forgotPassword()).thenAnswer((_) async {});
    when(() => mockViewModel.resetPassword()).thenAnswer((_) async {});
  });

  tearDown(() async {
    await mockViewModel.close();
  });

  group('Auth Flow Integration Tests', () {
    testWidgets('WelcomeScreen renders buttons and transitions correctly', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildAuthTestableWidget(const WelcomeScreen(), mockViewModel));
      await tester.pumpAndSettle();

      expect(find.text('Sign In'), findsOneWidget);
      expect(find.widgetWithText(AppButton, 'Create Account'), findsOneWidget);
      expect(find.text('Continue as Guest'), findsOneWidget);

      // Tap Sign In and verify navigation to Login Screen
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Welcome Back'), findsOneWidget);
    });

    testWidgets('LoginScreen displays validation errors on empty form submit', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildAuthTestableWidget(const LoginScreen(), mockViewModel));
      await tester.pumpAndSettle();

      // Tap Sign In button to trigger validation
      final signInBtn = find.widgetWithText(AppButton, 'Sign In');
      await tester.ensureVisible(signInBtn);
      await tester.tap(signInBtn);
      await tester.pumpAndSettle();

      // Assert validation errors are visible
      expect(find.text('this field is required'), findsWidgets);
      verifyNever(() => mockViewModel.login(rememberMe: any(named: "rememberMe")));
    });

    testWidgets('LoginScreen successfully calls BLoC and redirects on success', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildAuthTestableWidget(const LoginScreen(), mockViewModel));
      await tester.pumpAndSettle();

      // Enter valid fields
      mockViewModel.emailController.text = "test@example.com";
      mockViewModel.passwordController.text = "Password123";
      await tester.pumpAndSettle();

      // Tap sign in
      final signInBtn2 = find.widgetWithText(AppButton, 'Sign In');
      await tester.ensureVisible(signInBtn2);
      await tester.tap(signInBtn2);
      await tester.pumpAndSettle();

      // Verify login call on bloc
      verify(() => mockViewModel.login(rememberMe: false)).called(1);

      // Emit success state
      mockViewModel.emit(AuthLoading());
      await tester.pump();
      mockViewModel.emit(AuthSuccess("Logged in successfully"));
      await tester.pumpAndSettle();

      // Dialog should be shown with Success
      expect(find.text("Login Successful"), findsOneWidget);

      // Tap "OK" on AwesomeDialog to navigate to home
      // AwesomeDialog usually has a button with Ok text or similar
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.text('Home Screen'), findsOneWidget);
    });

    testWidgets('RegisterScreen displays validation errors', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildAuthTestableWidget(const RegisterScreen(), mockViewModel));
      await tester.pumpAndSettle();

      // Enter mismatched passwords
      mockViewModel.nameController.text = "user";
      mockViewModel.emailController.text = "user@example.com";
      mockViewModel.passwordController.text = "Password123";
      mockViewModel.confirmPasswordController.text = "Password321";
      await tester.pumpAndSettle();

      // Tap Sign Up
      final createAccBtn = find.widgetWithText(AppButton, 'Create Account');
      await tester.ensureVisible(createAccBtn);
      await tester.tap(createAccBtn);
      await tester.pumpAndSettle();

      expect(find.text('Passwords not matching'), findsWidgets);
      verifyNever(() => mockViewModel.register());
    });

    testWidgets('RegisterScreen submits and transitions to email verification', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildAuthTestableWidget(const RegisterScreen(), mockViewModel));
      await tester.pumpAndSettle();

      // Enter valid registration details
      mockViewModel.nameController.text = "user123";
      mockViewModel.emailController.text = "user@example.com";
      mockViewModel.passwordController.text = "Password123";
      mockViewModel.confirmPasswordController.text = "Password123";
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byType(Checkbox));
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      final createAccBtn2 = find.widgetWithText(AppButton, 'Create Account');
      await tester.ensureVisible(createAccBtn2);
      await tester.tap(createAccBtn2);
      await tester.pumpAndSettle();

      verify(() => mockViewModel.register()).called(1);

      mockViewModel.emit(AuthLoading());
      await tester.pump();
      mockViewModel.emit(AuthSuccess("User registered successfully"));
      await tester.pumpAndSettle();

      // Dialog should be shown with Success
      expect(find.text("Success"), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Should transition to Email Verification screen
      expect(find.text('Email Verification'), findsWidgets);
    });

    testWidgets('ForgotPasswordScreen flow submits successfully', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildAuthTestableWidget(const ForgotPasswordScreen(), mockViewModel));
      await tester.pumpAndSettle();

      mockViewModel.emailController.text = "user@example.com";
      await tester.pumpAndSettle();

      await tester.tap(find.text('Send Reset Link'));
      await tester.pumpAndSettle();

      verify(() => mockViewModel.forgotPassword()).called(1);

      mockViewModel.emit(AuthSuccess("Reset code sent"));
      await tester.pumpAndSettle();

      expect(find.text("Success"), findsOneWidget);
    });
  });
}
