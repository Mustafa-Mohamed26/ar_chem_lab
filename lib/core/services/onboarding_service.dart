import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static final OnboardingService _instance = OnboardingService._internal();

  factory OnboardingService() {
    return _instance;
  }

  OnboardingService._internal();

  static const String _onboardingKey = 'onboarding_complete';

  bool _isOnboardingComplete = false;
  bool get isOnboardingComplete => _isOnboardingComplete;

  Future<void> loadOnboardingStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isOnboardingComplete = prefs.getBool(_onboardingKey) ?? false;
    } catch (e) {
      debugPrint('Error loading onboarding status: $e');
    }
  }

  Future<void> setOnboardingComplete() async {
    try {
      _isOnboardingComplete = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingKey, true);
    } catch (e) {
      debugPrint('Error saving onboarding status: $e');
    }
  }
}
