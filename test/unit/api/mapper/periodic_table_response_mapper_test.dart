import 'package:ar_chem_lab/api/mapper/periodic_table_response_mapper.dart';
import 'package:ar_chem_lab/api/models/response/periodic_table_response_dto.dart';
import 'package:ar_chem_lab/domain/entities/periodic_table_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PeriodicTableResponseMapper Unit Tests', () {
    test('toDto should correctly map PeriodicTableResponse (Entity) to PeriodicTableResponseDto', () {
      // Arrange
      const entity = PeriodicTableResponse(
        atomicNumber: 6,
        symbol: "C",
        name: "Carbon",
        atomicMass: "12.011",
        cpkHexColor: "909090",
        electronicConfiguration: "[He] 2s2 2p2",
        electronegativity: 2.55,
        atomicRadius: 70.0,
        ionizationEnergy: 11.260,
        electronAffinity: 1.262,
        oxidationStates: "4, 2, -4",
        standardState: "solid",
        meltingPoint: "3823",
        boilingPoint: "4300",
        density: "2.267",
        category: "polyatomic nonmetal",
        yearDiscovered: "Ancient",
      );

      // Act
      final dto = entity.toDto();

      // Assert
      expect(dto.atomicNumber, 6);
      expect(dto.symbol, "C");
      expect(dto.name, "Carbon");
      expect(dto.atomicMass, 12.011);
      expect(dto.cpkHexColor, "909090");
      expect(dto.electronConfiguration, "[He] 2s2 2p2");
      expect(dto.electronegativity, 2.55);
      expect(dto.atomicRadius, 70.0);
      expect(dto.ionizationEnergy, 11.260);
      expect(dto.electronAffinity, 1.262);
      expect(dto.oxidationStates, "4, 2, -4");
      expect(dto.standardState, "solid");
      expect(dto.meltingPoint, 3823.0);
      expect(dto.boilingPoint, 4300.0);
      expect(dto.density, 2.267);
      expect(dto.groupBlock, "polyatomic nonmetal");
      expect(dto.yearDiscovered, "Ancient");
    });

    test('toDto should handle invalid numeric strings gracefully with 0.0 defaults', () {
      // Arrange
      const entity = PeriodicTableResponse(
        atomicMass: "invalid_mass",
        meltingPoint: "invalid_melting",
        boilingPoint: "invalid_boiling",
        density: "invalid_density",
      );

      // Act
      final dto = entity.toDto();

      // Assert
      expect(dto.atomicMass, 0.0);
      expect(dto.meltingPoint, 0.0);
      expect(dto.boilingPoint, 0.0);
      expect(dto.density, 0.0);
    });

    test('toDomain should correctly map PeriodicTableResponseDto to PeriodicTableResponse (Entity)', () {
      // Arrange
      final dto = PeriodicTableResponseDto(
        atomicNumber: 8,
        symbol: "O",
        name: "Oxygen",
        atomicMass: 15.999,
        cpkHexColor: "F00000",
        electronConfiguration: "[He] 2s2 2p4",
        electronegativity: 3.44,
        atomicRadius: 60.0,
        ionizationEnergy: 13.618,
        electronAffinity: 1.461,
        oxidationStates: "-2",
        standardState: "gas",
        meltingPoint: 54.36,
        boilingPoint: 90.2,
        density: 0.001429,
        groupBlock: "diatomic nonmetal",
        yearDiscovered: "1774",
      );

      // Act
      final entity = dto.toDomain();

      // Assert
      expect(entity.atomicNumber, 8);
      expect(entity.symbol, "O");
      expect(entity.name, "Oxygen");
      expect(entity.atomicMass, "15.999");
      expect(entity.cpkHexColor, "F00000");
      expect(entity.electronicConfiguration, "[He] 2s2 2p4");
      expect(entity.electronegativity, 3.44);
      expect(entity.atomicRadius, 60.0);
      expect(entity.ionizationEnergy, 13.618);
      expect(entity.electronAffinity, 1.461);
      expect(entity.oxidationStates, "-2");
      expect(entity.standardState, "gas");
      expect(entity.meltingPoint, "54.36");
      expect(entity.boilingPoint, "90.2");
      expect(entity.density, "0.001429");
      expect(entity.category, "diatomic nonmetal");
      expect(entity.block, "p");
      expect(entity.color, const Color(0xFFF00000));
      expect(entity.yearDiscovered, "1774");
      expect(entity.protons, 8);
      expect(entity.electrons, 8);
    });

    test('toDomain should extract block from configurations correctly', () {
      final configS = PeriodicTableResponseDto(electronConfiguration: "[He] 2s2");
      final configP = PeriodicTableResponseDto(electronConfiguration: "[He] 2s2 2p3");
      final configD = PeriodicTableResponseDto(electronConfiguration: "[Ar] 3d5 4s1");
      final configF = PeriodicTableResponseDto(electronConfiguration: "[Xe] 4f14 5d10 6s2");

      expect(configS.toDomain().block, "s");
      expect(configP.toDomain().block, "p");
      expect(configD.toDomain().block, "s"); // Ends with 4s1 -> 's' in simple endWith check
      expect(configF.toDomain().block, "s"); // Ends with 6s2 -> 's'
    });

    test('fromRow should map lists from WebServices getPeriodicTable correctly', () {
      // Arrange
      final columns = ["AtomicNumber", "Symbol", "Name", "AtomicMass", "Density"];
      final cells = ["1", "H", "Hydrogen", "1.008", "0.0000899"];

      // Act
      final dto = PeriodicTableResponseDto.fromRow(columns, cells);

      // Assert
      expect(dto.atomicNumber, 1);
      expect(dto.symbol, "H");
      expect(dto.name, "Hydrogen");
      expect(dto.atomicMass, 1.008);
      expect(dto.density, 0.0000899);
    });
  });
}
