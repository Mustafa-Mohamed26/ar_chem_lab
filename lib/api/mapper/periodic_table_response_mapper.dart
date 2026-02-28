import 'package:ar_chem_lab/api/models/response/periodic_table_response_dto.dart';
import 'package:ar_chem_lab/domain/entities/periodic_table_response.dart';

extension PeriodicTableResponseMapper on PeriodicTableResponse {
  PeriodicTableResponseDto toDto() => PeriodicTableResponseDto(
    atomicNumber: atomicNumber,
    symbol: symbol,
    name: name,
    atomicMass: double.tryParse(atomicMass) ?? 0.0,
    cpkHexColor: cpkHexColor,
    electronConfiguration: electronicConfiguration,
    electronegativity: electronegativity,
    atomicRadius: atomicRadius,
    ionizationEnergy: ionizationEnergy,
    electronAffinity: electronAffinity,
    oxidationStates: oxidationStates,
    standardState: standardState,
    meltingPoint: double.tryParse(meltingPoint) ?? 0.0,
    boilingPoint: double.tryParse(boilingPoint) ?? 0.0,
    density: double.tryParse(density) ?? 0.0,
    groupBlock: category,
    yearDiscovered: yearDiscovered,
  );
}
