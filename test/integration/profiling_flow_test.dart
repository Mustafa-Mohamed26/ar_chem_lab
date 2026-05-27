import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/presentation/profiling/steps/profiling_step1_goal.dart';
import 'package:ar_chem_lab/presentation/profiling/steps/profiling_step2_education.dart';
import 'package:ar_chem_lab/presentation/profiling/steps/profiling_step3_knowledge.dart';
import 'package:ar_chem_lab/presentation/profiling/steps/profiling_step4_assessment.dart';
import 'package:ar_chem_lab/presentation/profiling/user_profiling_screen.dart';
import 'package:ar_chem_lab/presentation/profiling/widgets/profiling_progress_bar.dart';
import 'package:ar_chem_lab/presentation/profiling/widgets/profiling_select_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget buildProfilingTestableWidget(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(360, 690),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, _) {
      return MaterialApp(
        routes: {
          AppRoutes.homeScreen: (context) =>
              const Scaffold(body: Text("Home Screen")),
          AppRoutes.profilingTestScreen: (context) =>
              const Scaffold(body: Text("Profiling Test Screen")),
        },
        home: Scaffold(body: child),
      );
    },
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Profiling Flow Integration Tests', () {
    testWidgets(
      'UserProfilingScreen loads first step goal screen and progress bar',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 1920);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          buildProfilingTestableWidget(const UserProfilingScreen()),
        );
        await tester.pumpAndSettle();

        // Should be on Step 1 (Personalize)
        expect(find.text('Personalize'), findsOneWidget);
        expect(find.byType(ProfilingProgressBar), findsOneWidget);
        expect(
          find.text('Why do you want to\nlearn chemistry?'),
          findsOneWidget,
        );

        // Verify progress label displays step 1
        expect(find.textContaining('STEP 1 OF 4'), findsOneWidget);
      },
    );

    //   testWidgets('Selecting card enables continue button and advances stepper', (WidgetTester tester) async {
    //     tester.view.physicalSize = const Size(1080, 1920);
    //     tester.view.devicePixelRatio = 1.0;
    //     addTearDown(tester.view.resetPhysicalSize);
    //     addTearDown(tester.view.resetDevicePixelRatio);

    //     await tester.pumpWidget(buildProfilingTestableWidget(const UserProfilingScreen()));
    //     await tester.pumpAndSettle();

    //     // Find selection cards
    //     final cardFinder = find.byType(ProfilingSelectCard);
    //     expect(cardFinder, findsNWidgets(4));

    //     // Tap first card "School Learning"
    //     await tester.tap(find.text('School Learning'));
    //     await tester.pumpAndSettle();

    //     // Continue button should be enabled. Let's tap it
    //     await tester.tap(find.text('Continue'));
    //     await tester.pumpAndSettle(const Duration(milliseconds: 500));

    //     // Should advance to Step 2 (Education)
    //     expect(find.text('Education'), findsOneWidget);
    //     expect(find.textContaining('STEP 2 OF 4'), findsOneWidget);
    //   });

    //   testWidgets('Stepping through all cards restores state on back button click', (WidgetTester tester) async {
    //     tester.view.physicalSize = const Size(1080, 1920);
    //     tester.view.devicePixelRatio = 1.0;
    //     addTearDown(tester.view.resetPhysicalSize);
    //     addTearDown(tester.view.resetDevicePixelRatio);

    //     await tester.pumpWidget(buildProfilingTestableWidget(const UserProfilingScreen()));
    //     await tester.pumpAndSettle();

    //     // Select goal and continue
    //     await tester.tap(find.text('School Learning'));
    //     await tester.pumpAndSettle();
    //     await tester.tap(find.text('Continue'));
    //     await tester.pumpAndSettle(const Duration(milliseconds: 500));

    //     // Select education level (e.g. Middle School or High School)
    //     // Let's check option titles in Step 2 or tap by index
    //     // We can just tap the first option card
    //     await tester.tap(find.byType(ProfilingSelectCard).first);
    //     await tester.pumpAndSettle();
    //     await tester.tap(find.text('Continue'));
    //     await tester.pumpAndSettle(const Duration(milliseconds: 500));

    //     // Should be on Step 3
    //     expect(find.text('Proficiency'), findsOneWidget);

    //     // Tap back button in AppBar
    //     await tester.tap(find.byTooltip('Go back'));
    //     await tester.pumpAndSettle(const Duration(milliseconds: 500));

    //     // Should be back to Step 2
    //     expect(find.text('Education'), findsOneWidget);
    //   });

    //   testWidgets('Step 4 Level Assess allows skipping and navigating to home', (WidgetTester tester) async {
    //     tester.view.physicalSize = const Size(1080, 1920);
    //     tester.view.devicePixelRatio = 1.0;
    //     addTearDown(tester.view.resetPhysicalSize);
    //     addTearDown(tester.view.resetDevicePixelRatio);

    //     await tester.pumpWidget(buildProfilingTestableWidget(const UserProfilingScreen()));
    //     await tester.pumpAndSettle();

    //     // Advance to step 2
    //     await tester.tap(find.text('School Learning'));
    //     await tester.pumpAndSettle();
    //     await tester.tap(find.text('Continue'));
    //     await tester.pumpAndSettle(const Duration(milliseconds: 500));

    //     // Advance to step 3
    //     await tester.tap(find.byType(ProfilingSelectCard).first);
    //     await tester.pumpAndSettle();
    //     await tester.tap(find.text('Continue'));
    //     await tester.pumpAndSettle(const Duration(milliseconds: 500));

    //     // Advance to step 4
    //     await tester.tap(find.byType(ProfilingSelectCard).first);
    //     await tester.pumpAndSettle();
    //     await tester.tap(find.text('Continue'));
    //     await tester.pumpAndSettle(const Duration(milliseconds: 500));

    //     // Verify we are on Step 4 (Level Assess)
    //     expect(find.text('Level Assess'), findsOneWidget);
    //     expect(find.text('Find Your Starting Point'), findsOneWidget);
    //     expect(find.text('Start Test  ›'), findsOneWidget);
    //     expect(find.text('Skip and explore later'), findsOneWidget);

    //     // Tap Skip and explore later
    //     await tester.tap(find.text('Skip and explore later'));
    //     await tester.pumpAndSettle(const Duration(milliseconds: 500));

    //     // Verify we are on home screen dummy layout
    //     expect(find.text('Home Screen'), findsOneWidget);
    //   });
  });
}
