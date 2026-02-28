import 'package:ar_chem_lab/domain/entities/periodic_table_response.dart';
import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PeriodicTableResponseDto {
  final int? atomicNumber;
  final String? symbol;
  final String? name;
  final double? atomicMass;
  final String? cpkHexColor;
  final String? electronConfiguration;
  final double? electronegativity;
  final double? atomicRadius;
  final double? ionizationEnergy;
  final double? electronAffinity;
  final String? oxidationStates;
  final String? standardState;
  final double? meltingPoint;
  final double? boilingPoint;
  final double? density;
  final String? groupBlock;
  final String? yearDiscovered;

  PeriodicTableResponseDto({
    this.atomicNumber,
    this.symbol,
    this.name,
    this.atomicMass,
    this.cpkHexColor,
    this.electronConfiguration,
    this.electronegativity,
    this.atomicRadius,
    this.ionizationEnergy,
    this.electronAffinity,
    this.oxidationStates,
    this.standardState,
    this.meltingPoint,
    this.boilingPoint,
    this.density,
    this.groupBlock,
    this.yearDiscovered,
  });

  factory PeriodicTableResponseDto.fromRow(
    List<String> columns,
    List<dynamic> cells,
  ) {
    final Map<String, dynamic> mapped = {};

    for (int i = 0; i < columns.length; i++) {
      mapped[columns[i]] = cells[i];
    }

    double? parseDouble(dynamic value) {
      if (value == null || value == "") return null;
      return double.tryParse(value.toString());
    }

    return PeriodicTableResponseDto(
      atomicNumber: int.tryParse(mapped["AtomicNumber"]?.toString() ?? ""),
      symbol: mapped["Symbol"],
      name: mapped["Name"],
      atomicMass: parseDouble(mapped["AtomicMass"]),
      cpkHexColor: mapped["CPKHexColor"],
      electronConfiguration: mapped["ElectronConfiguration"],
      electronegativity: parseDouble(mapped["Electronegativity"]),
      atomicRadius: parseDouble(mapped["AtomicRadius"]),
      ionizationEnergy: parseDouble(mapped["IonizationEnergy"]),
      electronAffinity: parseDouble(mapped["ElectronAffinity"]),
      oxidationStates: mapped["OxidationStates"],
      standardState: mapped["StandardState"],
      meltingPoint: parseDouble(mapped["MeltingPoint"]),
      boilingPoint: parseDouble(mapped["BoilingPoint"]),
      density: parseDouble(mapped["Density"]),
      groupBlock: mapped["GroupBlock"],
      yearDiscovered: mapped["YearDiscovered"],
    );
  }

  PeriodicTableResponse toDomain() {
    return PeriodicTableResponse(
      atomicNumber: atomicNumber ?? 0,
      symbol: symbol ?? "",
      name: name ?? "",
      atomicMass: atomicMass?.toString() ?? "",
      cpkHexColor: cpkHexColor,
      electronConfiguration: electronConfiguration,
      electronegativity: electronegativity,
      atomicRadius: atomicRadius,
      ionizationEnergy: ionizationEnergy,
      electronAffinity: electronAffinity,
      oxidationStates: oxidationStates,
      standardState: standardState,
      groupBlock: groupBlock,
      category: groupBlock ?? "unknown",
      block: _extractBlock(electronConfiguration),
      color: _parseColor(cpkHexColor),
      density: density?.toString() ?? "",
      meltingPoint: meltingPoint?.toString() ?? "",
      boilingPoint: boilingPoint?.toString() ?? "",
      yearDiscovered: yearDiscovered ?? "",
      protons: atomicNumber ?? 0,
      electrons: atomicNumber ?? 0,
      // Defaulting x and y for now as they aren't in the DTO yet
      x: 0,
      y: 0,
    );
  }

  static Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return AppColors.transparent;
    try {
      return Color(int.parse("0xFF$hex"));
    } catch (_) {
      return AppColors.transparent;
    }
  }

  static String _extractBlock(String? config) {
    if (config == null || config.isEmpty) return "";
    // Very simple heuristic: last character usually indicates block
    final trimmed = config.trim();
    if (trimmed.endsWith('s')) return 's';
    if (trimmed.endsWith('p')) return 'p';
    if (trimmed.endsWith('d')) return 'd';
    if (trimmed.endsWith('f')) return 'f';
    // If it ends with a number (like 3s2), we look for the letter before it
    final match = RegExp(r'([spdf])\d*$').firstMatch(trimmed);
    return match?.group(1) ?? "";
  }
}
