import 'dart:async';
import 'package:ar_chem_lab/config/di/di.dart';
import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/domain/entities/periodic_table_response.dart';
import 'package:ar_chem_lab/presentation/periodic_table/cubit/periodic_table_states.dart';
import 'package:ar_chem_lab/presentation/periodic_table/cubit/periodic_table_view_model.dart';
import 'package:ar_chem_lab/presentation/periodic_table/element_detail_screen.dart';
import 'package:ar_chem_lab/presentation/periodic_table/element_tile.dart';
import 'package:ar_chem_lab/presentation/periodic_table/elements_data.dart';
import 'package:ar_chem_lab/presentation/periodic_table/periodic_table_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockPeriodicTableViewModel extends Mock implements PeriodicTableViewModel {
  final _stateController = StreamController<PeriodicTableState>.broadcast();
  PeriodicTableState _state = PeriodicTableLoading();
  int getPeriodicTableCallCount = 0;

  void emit(PeriodicTableState state) {
    _state = state;
    _stateController.add(state);
  }

  @override
  PeriodicTableState get state => _state;

  @override
  Stream<PeriodicTableState> get stream => _stateController.stream;

  @override
  Future<void> getPeriodicTable() async {
    getPeriodicTableCallCount++;
  }

  @override
  Future<void> close() async {
    await _stateController.close();
  }
}

Widget buildPeriodicTableTestableWidget(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(360, 690),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, _) {
      return MaterialApp(
        routes: {
          AppRoutes.periodicTableScreen: (context) => const PeriodicTableScreen(),
          AppRoutes.elementDetailScreen: (context) => const ElementDetailScreen(),
        },
        home: child,
      );
    },
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockPeriodicTableViewModel mockViewModel;

  setUp(() async {
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exceptionAsString().contains('overflowed by')) {
        return; // Ignore overflow errors
      }
      originalOnError?.call(details);
    };

    SharedPreferences.setMockInitialValues({});
    mockViewModel = MockPeriodicTableViewModel();
    
    // Register mockViewModel to GetIt
    await getIt.reset();
    getIt.registerFactory<PeriodicTableViewModel>(() => mockViewModel);
  });

  tearDown(() async {
    await mockViewModel.close();
  });

  group('Periodic Table Flow Integration Tests', () {
    testWidgets('Screen shows loading indicator initially', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      mockViewModel.emit(PeriodicTableLoading());

      await tester.pumpWidget(buildPeriodicTableTestableWidget(const PeriodicTableScreen()));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Screen shows error layout and retry triggers fetch', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      mockViewModel.emit(PeriodicTableError(message: "No Internet Connection"));

      await tester.pumpWidget(buildPeriodicTableTestableWidget(const PeriodicTableScreen()));
      await tester.pumpAndSettle();

      expect(find.text("No Internet Connection"), findsOneWidget);
      expect(find.text("Retry"), findsOneWidget);

      await tester.tap(find.text("Retry"));
      await tester.pump();

      expect(mockViewModel.getPeriodicTableCallCount, 2); // One in initState, one on Retry
    });

    testWidgets('Screen displays elements grid when successful and allows clicking', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 2000); // Larger to display grid fully
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final elements = ElementData.allElements.take(10).toList();
      mockViewModel.emit(PeriodicTableSuccess(elements: elements));

      await tester.pumpWidget(buildPeriodicTableTestableWidget(const PeriodicTableScreen()));
      await tester.pumpAndSettle();

      // Verify that element tiles for Hydrogen (H) and Helium (He) are rendered
      expect(find.byType(ElementTile), findsAtLeastNWidgets(2));
      expect(find.text('H'), findsOneWidget);
      expect(find.text('He'), findsOneWidget);

      // Tap Hydrogen tile to trigger detail navigation
      await tester.tap(find.text('H'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // We should be on ElementDetailScreen
      expect(find.text('Hydrogen'), findsWidgets); // Title and cards
      expect(find.text('1.008 (g/mol)'), findsOneWidget);
      expect(find.text('Overview'), findsOneWidget);
    });
  });
}
