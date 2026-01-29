import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ElementModel {
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

  const ElementModel({
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
  });
}
