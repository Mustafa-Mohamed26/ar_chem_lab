import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/presentation/auth/login_screen.dart';
import 'package:ar_chem_lab/presentation/auth/register_screen.dart';
import 'package:ar_chem_lab/presentation/auth/forgot_password_screen.dart';
import 'package:ar_chem_lab/presentation/auth/create_new_password_screen.dart';
import 'package:ar_chem_lab/presentation/auth/password_changed_screen.dart';
import 'package:ar_chem_lab/presentation/chat_bot/chat_bot_screen.dart';
import 'package:ar_chem_lab/presentation/history/history_screen.dart';
import 'package:ar_chem_lab/presentation/home/home_screen.dart';
import 'package:ar_chem_lab/presentation/onboarding/onboarding_screen.dart';
import 'package:ar_chem_lab/presentation/auth/welcome_screen.dart';
import 'package:ar_chem_lab/presentation/auth/otp_verification_screen.dart';
import 'package:ar_chem_lab/presentation/periodic_table/element_detail_screen.dart';
import 'package:ar_chem_lab/presentation/periodic_table/periodic_table_screen.dart';
import 'package:flutter/material.dart';

class AppRouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onboarding:
        return _buildPageRoute(OnboardingScreen());
      case AppRoutes.welcomeScreen:
        return _buildPageRoute(const WelcomeScreen());
      case AppRoutes.homeScreen:
        return _buildPageRoute(HomeScreen());
      case AppRoutes.chatBotScreen:
        return _buildPageRoute(ChatBotScreen());
      case AppRoutes.historyScreen:
        return _buildPageRoute(HistoryScreen());
      case AppRoutes.periodicTableScreen:
        return _buildPageRoute(PeriodicTableScreen());
      case AppRoutes.elementDetailScreen:
        return _buildPageRoute(ElementDetailScreen());
      case AppRoutes.loginScreen:
        return _buildPageRoute(const LoginScreen());
      case AppRoutes.registerScreen:
        return _buildPageRoute(const RegisterScreen());
      case AppRoutes.forgotPasswordScreen:
        return _buildPageRoute(const ForgotPasswordScreen());
      case AppRoutes.createNewPasswordScreen:
        return _buildPageRoute(const CreateNewPasswordScreen());
      case AppRoutes.passwordChangedScreen:
        return _buildPageRoute(const PasswordChangedScreen());
      case AppRoutes.otpVerificationScreen:
        return _buildPageRoute(const OTPVerificationScreen());
      default:
        return _errorRoute();
    }
  }

  static PageRouteBuilder _buildPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.05, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        var slideTween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var fadeTween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

        return FadeTransition(
          opacity: animation.drive(fadeTween),
          child: SlideTransition(
            position: animation.drive(slideTween),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Page not found')),
      );
    });
  }
}
