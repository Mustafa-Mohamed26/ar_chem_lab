import 'package:shared_preferences/shared_preferences.dart';
import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/core/services/onboarding_service.dart';

/// Service responsible for determining the initial route on app startup
class InitialRouteResolver {
  /// Determines which route the app should start with based on app state
  static Future<String> getInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final hasToken = prefs.getString('access_token') != null;
    final rememberMe = prefs.getBool('remember_me') ?? false;

    // Priority 1: Check if onboarding is incomplete
    if (!OnboardingService().isOnboardingComplete) {
      return AppRoutes.onboarding;
    }

    // Priority 2: Check if user is logged in and has remember_me enabled
    if (hasToken && rememberMe) {
      return AppRoutes.homeScreen;
    }

    // Default: Show welcome screen
    return AppRoutes.welcomeScreen;
  }
}
