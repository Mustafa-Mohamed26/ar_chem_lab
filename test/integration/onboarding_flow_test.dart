import 'package:ar_chem_lab/core/services/onboarding_service.dart';
import 'package:ar_chem_lab/presentation/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget buildTestableWidget(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(360, 690),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, _) {
      return MaterialApp(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(body: child),
            settings: settings,
          );
        },
        home: child,
      );
    },
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Onboarding Flow Integration Tests', () {
    testWidgets('Onboarding page loads and displays intro text', (WidgetTester tester) async {
      // Set larger screen surface to avoid layout/flex overflows
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestableWidget(const OnboardingScreen()));
      await tester.pumpAndSettle();

      // Check first slide content
      expect(find.text('Welcome to AR ChemLab.'), findsOneWidget);
      expect(
        find.text('Discover science in a new dimension through interactive augmented reality'),
        findsOneWidget,
      );
      expect(find.text('Let’s start'), findsOneWidget);
    });

    testWidgets('Tapping Next progresses through slides and back button goes back', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestableWidget(const OnboardingScreen()));
      await tester.pumpAndSettle();

      // Tap first button "Let’s start"
      await tester.tap(find.text('Let’s start'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Should be on slide 1
      expect(find.text('Explore chemistry in a whole new way'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Back'), findsOneWidget);

      // Tap "Back" to go to slide 0
      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.text('Welcome to AR ChemLab.'), findsOneWidget);
      expect(find.text('Back'), findsNothing);
    });

    testWidgets('Tapping Get Started completes onboarding and navigates', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      // Verify onboarding status is initially false
      final service = OnboardingService();
      await service.loadOnboardingStatus();
      expect(service.isOnboardingComplete, isFalse);

      await tester.pumpWidget(buildTestableWidget(const OnboardingScreen()));
      await tester.pumpAndSettle();

      // Tap Let's Start
      await tester.tap(find.text('Let’s start'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Tap Next
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Verify slide 2 content
      expect(find.text('Safe and interactive Experiments'), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);

      // Tap Get Started
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Verify onboarding complete is written
      expect(service.isOnboardingComplete, isTrue);
    });
  });
}
