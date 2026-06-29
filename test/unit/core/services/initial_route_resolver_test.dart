import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/core/services/initial_route_resolver.dart';
import 'package:ar_chem_lab/core/services/onboarding_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('InitialRouteResolver Unit Tests', () {
    test('should return onboarding route if onboarding is not complete', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({
        'onboarding_complete': false,
        'access_token': 'some_jwt_token',
        'remember_me': true,
      });
      await OnboardingService().loadOnboardingStatus();

      // Act
      final initialRoute = await InitialRouteResolver.getInitialRoute();

      // Assert
      expect(initialRoute, AppRoutes.onboarding);
    });

    test('should return homeScreen if onboarding is complete, token is present, and rememberMe is true', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({
        'onboarding_complete': true,
        'access_token': 'some_jwt_token',
        'remember_me': true,
      });
      await OnboardingService().loadOnboardingStatus();

      // Act
      final initialRoute = await InitialRouteResolver.getInitialRoute();

      // Assert
      expect(initialRoute, AppRoutes.homeScreen);
    });

    test('should return welcomeScreen if onboarding is complete but token is missing', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({
        'onboarding_complete': true,
        'remember_me': true,
      });
      await OnboardingService().loadOnboardingStatus();

      // Act
      final initialRoute = await InitialRouteResolver.getInitialRoute();

      // Assert
      expect(initialRoute, AppRoutes.welcomeScreen);
    });

    test('should return welcomeScreen if onboarding is complete but rememberMe is false', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({
        'onboarding_complete': true,
        'access_token': 'some_jwt_token',
        'remember_me': false,
      });
      await OnboardingService().loadOnboardingStatus();

      // Act
      final initialRoute = await InitialRouteResolver.getInitialRoute();

      // Assert
      expect(initialRoute, AppRoutes.welcomeScreen);
    });
  });
}
