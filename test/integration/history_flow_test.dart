import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/presentation/history/history_screen.dart';
import 'package:ar_chem_lab/presentation/widget/history_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget buildHistoryTestableWidget(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(360, 690),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, _) {
      return MaterialApp(
        routes: {
          AppRoutes.profileScreen: (context) => const Scaffold(body: Text("Profile Screen")),
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

  group('History Flow Integration Tests', () {
    testWidgets('HistoryScreen loads and renders all mock experiments', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildHistoryTestableWidget(const HistoryScreen()));
      await tester.pumpAndSettle();

      // Check header title
      expect(find.text("EXPERIMENT "), findsOneWidget);
      expect(find.text("HISTORY"), findsOneWidget);

      // Verify that all 4 initial mock cards are rendered
      expect(find.byType(HistoryCard), findsNWidgets(4));
      expect(find.text("Water Formation"), findsOneWidget);
      expect(find.text("Produce CO2"), findsOneWidget);
      expect(find.text("Methane Synthesis"), findsOneWidget);
      expect(find.text("Acid Neutralization"), findsOneWidget);
    });

    testWidgets('Searching filters the experiment records', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildHistoryTestableWidget(const HistoryScreen()));
      await tester.pumpAndSettle();

      // Type "CO2" in search field
      final searchInput = find.byType(TextField);
      await tester.enterText(searchInput, "CO2");
      await tester.pumpAndSettle();

      // List should filter to show only "Produce CO2"
      expect(find.byType(HistoryCard), findsOneWidget);
      expect(find.text("Produce CO2"), findsOneWidget);
      expect(find.text("Water Formation"), findsNothing);
    });

    testWidgets('Tapping Successful filter chip updates the list', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildHistoryTestableWidget(const HistoryScreen()));
      await tester.pumpAndSettle();

      // Tap "Successful" chip
      await tester.tap(find.text("Successful"));
      await tester.pumpAndSettle();

      // Should show only the 3 successful experiments, Methane Synthesis should be hidden
      expect(find.byType(HistoryCard), findsNWidgets(3));
      expect(find.text("Methane Synthesis"), findsNothing);
      expect(find.text("Water Formation"), findsOneWidget);
    });

    testWidgets('Tapping Failed filter chip shows only failed records', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildHistoryTestableWidget(const HistoryScreen()));
      await tester.pumpAndSettle();

      // Tap "Failed" chip
      await tester.tap(find.text("Failed"));
      await tester.pumpAndSettle();

      // Should show only 1 experiment "Methane Synthesis"
      expect(find.byType(HistoryCard), findsOneWidget);
      expect(find.text("Methane Synthesis"), findsOneWidget);
      expect(find.text("Water Formation"), findsNothing);
    });
  });
}
