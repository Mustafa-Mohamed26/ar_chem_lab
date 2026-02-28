import 'package:ar_chem_lab/domain/entities/periodic_table_response.dart';
import 'package:ar_chem_lab/domain/use_cases/get_periodic_table_use_case.dart';
import 'package:ar_chem_lab/presentation/periodic_table/cubit/periodic_table_states.dart';
import 'package:ar_chem_lab/presentation/periodic_table/elements_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class PeriodicTableViewModel extends Cubit<PeriodicTableState> {
  final GetPeriodicTableUseCase _getPeriodicTableUseCase;

  PeriodicTableViewModel(this._getPeriodicTableUseCase)
    : super(PeriodicTableInitial());

  Future<void> getPeriodicTable() async {
    emit(PeriodicTableLoading());
    try {
      // 1. Get local data
      final localElements = ElementData.allElements;

      // 2. Fetch API data
      final apiElements = await _getPeriodicTableUseCase.invoke();

      if (apiElements == null || apiElements.isEmpty) {
        // If API fails or is empty, we can still show local data or show error
        // Given the requirement, we should probably show local data at least
        emit(PeriodicTableSuccess(elements: localElements));
        return;
      }

      // 3. Merge data
      final mergedElements = localElements.map((local) {
        // Create a new PeriodicTableResponse with combined data
        // We use a separate variable to check for match because PeriodTableResponse.== only checks atomicNumber
        final apiMatch = apiElements.cast<PeriodicTableResponse?>().firstWhere(
          (api) => api?.atomicNumber == local.atomicNumber,
          orElse: () => null,
        );

        if (apiMatch == null) return local;
        return PeriodicTableResponse(
          atomicNumber: local.atomicNumber,
          symbol: local.symbol,
          name: local.name,
          atomicMass: apiMatch.atomicMass.isNotEmpty
              ? apiMatch.atomicMass
              : local.atomicMass,
          category: local.category,
          electronicConfiguration: local.electronicConfiguration,
          x: local.x,
          y: local.y,
          block: local.block,
          summary: local.summary,
          color: local.color,
          latinName: local.latinName,
          density: apiMatch.density.isNotEmpty
              ? apiMatch.density
              : local.density,
          electrons: local.electrons,
          protons: local.protons,
          neutrons: local.neutrons,
          valence: local.valence,
          model3DPath: local.model3DPath,
          meltingPoint: apiMatch.meltingPoint,
          boilingPoint: apiMatch.boilingPoint,
          ionisation: apiMatch.ionisation,
          radioactive: apiMatch.radioactive,
          yearDiscovered: apiMatch.yearDiscovered,
          cpkHexColor: apiMatch.cpkHexColor,
          electronConfiguration: apiMatch.electronConfiguration,
          electronegativity: apiMatch.electronegativity,
          atomicRadius: apiMatch.atomicRadius,
          ionizationEnergy: apiMatch.ionizationEnergy,
          electronAffinity: apiMatch.electronAffinity,
          oxidationStates: apiMatch.oxidationStates,
          standardState: apiMatch.standardState,
          groupBlock: apiMatch.groupBlock,
        );
      }).toList();

      emit(PeriodicTableSuccess(elements: mergedElements));
    } catch (e) {
      emit(PeriodicTableError(message: e.toString()));
    }
  }
}
