import 'package:ar_chem_lab/api/models/response/login_response_dto.dart';
import 'package:ar_chem_lab/domain/entities/user.dart';
import 'package:ar_chem_lab/domain/use_cases/auth_use_case.dart';
import 'package:ar_chem_lab/domain/use_cases/get_profile_use_case.dart';
import 'package:ar_chem_lab/presentation/auth/cubit/auth_states.dart';
import 'package:ar_chem_lab/presentation/auth/cubit/auth_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthUseCase extends Mock implements AuthUseCase {}

class MockGetProfileUseCase extends Mock implements GetProfileUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthViewModel viewModel;
  late MockAuthUseCase mockAuthUseCase;
  late MockGetProfileUseCase mockGetProfileUseCase;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockAuthUseCase = MockAuthUseCase();
    mockGetProfileUseCase = MockGetProfileUseCase();
    viewModel = AuthViewModel(
      authUseCase: mockAuthUseCase,
      getProfileUseCase: mockGetProfileUseCase,
    );
  });

  tearDown(() {
    viewModel.close();
  });

  group('AuthViewModel Unit Tests', () {
    test('initial state should be AuthInitial', () {
      expect(viewModel.state, isA<AuthInitial>());
    });

    group('register', () {
      test('success emits AuthLoading and AuthSuccess', () async {
        viewModel.nameController.text = "testuser";
        viewModel.emailController.text = "test@example.com";
        viewModel.passwordController.text = "Password123";

        when(() => mockAuthUseCase.register("testuser", "test@example.com", "Password123"))
            .thenAnswer((_) async => "User registered successfully");

        final streamFuture = expectLater(
          viewModel.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            isA<AuthSuccess>().having((s) => s.message, 'message', "User registered successfully"),
          ]),
        );

        await viewModel.register();
        await streamFuture;
      });

      test('failure emits AuthLoading and AuthError', () async {
        viewModel.nameController.text = "testuser";
        viewModel.emailController.text = "test@example.com";
        viewModel.passwordController.text = "Password123";

        when(() => mockAuthUseCase.register("testuser", "test@example.com", "Password123"))
            .thenAnswer((_) async => "Email already registered");

        final streamFuture = expectLater(
          viewModel.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            isA<AuthError>().having((s) => s.message, 'message', "Email already registered"),
          ]),
        );

        await viewModel.register();
        await streamFuture;
      });
    });

    group('verifyEmail', () {
      test('success emits AuthLoading and AuthSuccess', () async {
        viewModel.emailController.text = "test@example.com";
        when(() => mockAuthUseCase.verifyEmail("test@example.com", "123456"))
            .thenAnswer((_) async => "Email verified successfully");

        final streamFuture = expectLater(
          viewModel.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            isA<AuthSuccess>().having((s) => s.message, 'message', "Email verified successfully"),
          ]),
        );

        await viewModel.verifyEmail("123456");
        await streamFuture;
      });
    });

    group('forgotPassword', () {
      test('empty email emits AuthError directly without calling usecase', () async {
        viewModel.emailController.text = "";

        final streamFuture = expectLater(
          viewModel.stream,
          emitsInOrder([
            isA<AuthError>().having((s) => s.message, 'message', "Please enter your email address"),
          ]),
        );

        await viewModel.forgotPassword();
        await streamFuture;

        verifyNever(() => mockAuthUseCase.forgotPassword(any()));
      });

      test('success emits AuthLoading and AuthSuccess', () async {
        viewModel.emailController.text = "test@example.com";
        when(() => mockAuthUseCase.forgotPassword("test@example.com"))
            .thenAnswer((_) async => "Reset code sent successfully");

        final streamFuture = expectLater(
          viewModel.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            isA<AuthSuccess>().having((s) => s.message, 'message', "Reset code sent successfully"),
          ]),
        );

        await viewModel.forgotPassword();
        await streamFuture;
      });
    });

    group('resetPassword', () {
      test('password mismatch emits AuthError directly', () async {
        viewModel.passwordController.text = "Pass123";
        viewModel.confirmPasswordController.text = "Pass321";

        final streamFuture = expectLater(
          viewModel.stream,
          emitsInOrder([
            isA<AuthError>().having((s) => s.message, 'message', "Passwords do not match"),
          ]),
        );

        await viewModel.resetPassword();
        await streamFuture;

        verifyNever(() => mockAuthUseCase.resetPassword(any(), any(), any()));
      });

      test('success emits AuthLoading and AuthSuccess and clears controllers', () async {
        viewModel.emailController.text = "test@example.com";
        viewModel.resetCode = "123456";
        viewModel.passwordController.text = "Password123";
        viewModel.confirmPasswordController.text = "Password123";

        when(() => mockAuthUseCase.resetPassword("test@example.com", "123456", "Password123"))
            .thenAnswer((_) async => "Password reset successfully");

        final streamFuture = expectLater(
          viewModel.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            isA<AuthSuccess>().having((s) => s.message, 'message', "Password reset successfully"),
          ]),
        );

        await viewModel.resetPassword();
        await streamFuture;

        expect(viewModel.resetCode, isNull);
        expect(viewModel.passwordController.text, isEmpty);
        expect(viewModel.confirmPasswordController.text, isEmpty);
      });
    });

    group('login', () {
      test('success emits AuthLoading and AuthSuccess and stores credentials', () async {
        viewModel.emailController.text = "test@example.com";
        viewModel.passwordController.text = "Password123";

        final response = LoginResponseDto(
          accessToken: "access_jwt",
          refreshToken: "refresh_jwt",
          tokenType: "Bearer",
        );

        when(() => mockAuthUseCase.login("test@example.com", "Password123"))
            .thenAnswer((_) async => response);

        final streamFuture = expectLater(
          viewModel.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            isA<AuthSuccess>().having((s) => s.message, 'message', "Logged in successfully"),
          ]),
        );

        await viewModel.login(rememberMe: true);
        await streamFuture;

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('access_token'), "access_jwt");
        expect(prefs.getString('refresh_token'), "refresh_jwt");
        expect(prefs.getBool('remember_me'), isTrue);
      });
    });

    group('logout', () {
      test('clears preferences, controllers and emits AuthInitial', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', 'token');
        viewModel.nameController.text = "Name";

        final streamFuture = expectLater(
          viewModel.stream,
          emitsInOrder([isA<AuthInitial>()]),
        );

        await viewModel.logout();
        await streamFuture;

        expect(prefs.getString('access_token'), isNull);
        expect(viewModel.nameController.text, isEmpty);
      });
    });

    group('getProfile', () {
      test('success emits ProfileLoading and ProfileSuccess', () async {
        final user = User(
          id: 1,
          username: "testuser",
          email: "test@example.com",
          hashedPassword: "hashed",
        );

        when(() => mockGetProfileUseCase.invoke()).thenAnswer((_) async => user);

        final streamFuture = expectLater(
          viewModel.stream,
          emitsInOrder([
            isA<ProfileLoading>(),
            isA<ProfileSuccess>().having((s) => s.user, 'user', user),
          ]),
        );

        await viewModel.getProfile();
        await streamFuture;
      });

      test('failure emits ProfileLoading and AuthError', () async {
        when(() => mockGetProfileUseCase.invoke()).thenThrow(Exception("Failed to load profile"));

        final streamFuture = expectLater(
          viewModel.stream,
          emitsInOrder([
            isA<ProfileLoading>(),
            isA<AuthError>().having((s) => s.message, 'message', contains("Failed to load profile")),
          ]),
        );

        await viewModel.getProfile();
        await streamFuture;
      });
    });
  });
}
