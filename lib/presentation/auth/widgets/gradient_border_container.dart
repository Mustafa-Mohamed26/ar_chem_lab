import 'package:flutter/material.dart';

class GradientBorderContainer extends StatelessWidget {
  // --- PROPERTIES ---
  final Widget child;
  final double borderWidth;
  final double borderRadius;
  final Gradient gradient;
  final Color? innerBackgroundColor;
  final Gradient? innerGradientBackground;

  // --- CONSTRUCTOR ---
  const GradientBorderContainer({
    super.key,
    required this.child,
    this.borderWidth = 2.0,
    this.borderRadius = 24.0,
    required this.gradient,
    this.innerBackgroundColor,
    this.innerGradientBackground,
  });

  // --- BUILD METHOD ---

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: EdgeInsets.all(borderWidth),
      child: Container(
        decoration: BoxDecoration(
          color: innerBackgroundColor,
          gradient: innerGradientBackground,
          borderRadius: BorderRadius.circular(borderRadius - borderWidth),
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}
