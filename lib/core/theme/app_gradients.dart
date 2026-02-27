import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppGradients {
  AppGradients._(); // prevent instantiation

  static LinearGradient primary({
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
    List<Color>? colors,
    List<double>? stops,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: colors ??
          const [
            AppColors.midnightBlue,
            AppColors.royalBlue,
          ],
      stops: stops ?? const [0.47, 1.0],
    );
  }
}
