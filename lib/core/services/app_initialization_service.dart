import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ar_chem_lab/config/bloc_observer.dart';
import 'package:ar_chem_lab/config/di/di.dart';
import 'package:ar_chem_lab/core/services/onboarding_service.dart';
import 'package:ar_chem_lab/core/services/view_history_service.dart';

/// Service responsible for initializing the application
class AppInitializationService {
  /// Performs all necessary initialization steps for the app
  static Future<void> initialize() async {
    // Set up Flutter binding
    WidgetsFlutterBinding.ensureInitialized();

    // Set up BLoC observer
    Bloc.observer = MyBlocObserver();

    // Initialize screen utilities
    await ScreenUtil.ensureScreenSize();

    // Configure dependency injection
    configureDependencies();

    // Load application data in parallel
    await Future.wait([
      ViewHistoryService().loadHistory(),
      OnboardingService().loadOnboardingStatus(),
    ]);

    // Load environment variables
    await dotenv.load(fileName: ".env");
  }
}
