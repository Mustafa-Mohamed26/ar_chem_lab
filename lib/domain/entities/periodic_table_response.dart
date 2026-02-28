import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PeriodicTableResponse {
  final String symbol;
  final String name;
  final int atomicNumber;
  final Color color;
  final String atomicMass;
  final String electronicConfiguration;
  final String summary;
  final String category;
  final String block;
  final int x; // Grid column (1-18)
  final int y; // Grid row (1-7+)
  final bool isEmpty;

  final String? model3DPath;
  final String latinName;
  final String density;
  final String meltingPoint;
  final String boilingPoint;
  final int electrons;
  final int protons;
  final int neutrons;
  final String valence;
  final String ionisation;
  final String radioactive;
  final String yearDiscovered;

  final String? cpkHexColor;
  final String? electronConfiguration;
  final double? electronegativity;
  final double? atomicRadius;
  final double? ionizationEnergy;
  final double? electronAffinity;
  final String? oxidationStates;
  final String? standardState;
  final String? groupBlock;

  const PeriodicTableResponse({
    this.symbol = '',
    this.name = '',
    this.atomicNumber = 0,
    this.color = AppColors.transparent,
    this.atomicMass = '',
    this.electronicConfiguration = '',
    this.summary = '',
    this.category = '',
    this.block = '',
    this.x = 0,
    this.y = 0,
    this.isEmpty = false,
    this.model3DPath,
    this.latinName = "",
    this.density = "",
    this.meltingPoint = "",
    this.boilingPoint = "",
    this.electrons = 0,
    this.protons = 0,
    this.neutrons = 0,
    this.valence = "",
    this.ionisation = "",
    this.radioactive = "",
    this.yearDiscovered = "",
    this.cpkHexColor,
    this.electronConfiguration,
    this.electronegativity,
    this.atomicRadius,
    this.ionizationEnergy,
    this.electronAffinity,
    this.oxidationStates,
    this.standardState,
    this.groupBlock,
  });

  // Helper to get group name (e.g. IA, IIA)
  String get groupName {
    if (x == 1) return "IA";
    if (x == 2) return "IIA";
    if (x == 18) return "VIIIA";
    return "$x";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PeriodicTableResponse &&
          runtimeType == other.runtimeType &&
          atomicNumber == other.atomicNumber;

  @override
  int get hashCode => atomicNumber.hashCode;
}
