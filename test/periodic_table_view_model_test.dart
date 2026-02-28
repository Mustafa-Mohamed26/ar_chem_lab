import 'package:ar_chem_lab/domain/entities/periodic_table_response.dart';
import 'package:ar_chem_lab/domain/use_cases/get_periodic_table_use_case.dart';
import 'package:ar_chem_lab/presentation/periodic_table/cubit/periodic_table_states.dart';
import 'package:ar_chem_lab/presentation/periodic_table/cubit/periodic_table_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPeriodicTableUseCase extends Mock
    implements GetPeriodicTableUseCase {}

void main() {
  late PeriodicTableViewModel viewModel;
  late MockGetPeriodicTableUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetPeriodicTableUseCase();
    viewModel = PeriodicTableViewModel(mockUseCase);
  });

  test('should merge API data with local data correctly', () async {
    // Arrange
    final apiElements = [
      const PeriodicTableResponse(
        atomicNumber: 1,
        name: "Hydrogen",
        symbol: "H",
        atomicMass:
            "1.008 UNCHANGED", // Should be updated if implementation was slightly different, but here we check if it merges at all
        density: "NEW DENSITY",
        boilingPoint: "NEW BOILING POINT",
      ),
    ];

    when(() => mockUseCase.invoke()).thenAnswer((_) async => apiElements);

    // Act
    await viewModel.getPeriodicTable();

    // Assert
    final state = viewModel.state;
    expect(state, isA<PeriodicTableSuccess>());
    if (state is PeriodicTableSuccess) {
      final h = state.elements.firstWhere((e) => e.atomicNumber == 1);
      // Local Hydrogen has density "0.0000899". If merging works, it should be "NEW DENSITY"
      expect(h.density, "NEW DENSITY");
      expect(h.boilingPoint, "NEW BOILING POINT");
      // Verify other fields still come from local data (e.g. x, y)
      expect(h.x, 1);
      expect(h.y, 1);
    }
  });

  test('should fallback to local data when API returns empty', () async {
    // Arrange
    when(() => mockUseCase.invoke()).thenAnswer((_) async => []);

    // Act
    await viewModel.getPeriodicTable();

    // Assert
    final state = viewModel.state;
    expect(state, isA<PeriodicTableSuccess>());
    if (state is PeriodicTableSuccess) {
      final h = state.elements.firstWhere((e) => e.atomicNumber == 1);
      expect(h.density, "0.0000899"); // Original local value
    }
  });
}
