import 'package:ar_chem_lab/core/services/onboarding_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OnboardingService Unit Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Singleton instances should be identical', () {
      final instance1 = OnboardingService();
      final instance2 = OnboardingService();
      expect(identical(instance1, instance2), isTrue);
    });

    test('Initial onboarding status is false, loading reads from storage correctly', () async {
      final service = OnboardingService();
      
      // Let's verify standard initial state (or reload after mock preferences set)
      await service.loadOnboardingStatus();
      expect(service.isOnboardingComplete, isFalse);

      // Now set mock values and reload
      SharedPreferences.setMockInitialValues({'onboarding_complete': true});
      await service.loadOnboardingStatus();
      expect(service.isOnboardingComplete, isTrue);
    });

    test('Setting onboarding complete updates state and writes to shared preferences', () async {
      SharedPreferences.setMockInitialValues({'onboarding_complete': false});
      final service = OnboardingService();
      await service.loadOnboardingStatus();
      expect(service.isOnboardingComplete, isFalse);

      await service.setOnboardingComplete();
      expect(service.isOnboardingComplete, isTrue);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('onboarding_complete'), isTrue);
    });
  });
}
