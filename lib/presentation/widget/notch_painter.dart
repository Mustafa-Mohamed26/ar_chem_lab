import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Define the Gradient for the border
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Paint paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [AppColors.electricBlue, AppColors.skyBlue],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7.0;

    // 2. Create the Path
    final path = Path();
    double notchWidth = 150.0.w;
    double notchHeight = 52.0.h;
    double centerX = size.width / 2;
    double radius = 15.0; // Corner radius for the bar

    // Start from top left corner
    path.moveTo(radius, 0);

    // Line to the start of the notch
    path.lineTo(centerX - (notchWidth / 3) - 15, 0);

    // The "S-Curve" into the notch
    path.cubicTo(
      centerX - (notchWidth / 4),
      0, // Control Point 1
      centerX - (notchWidth / 3),
      notchHeight, // Control Point 2
      centerX,
      notchHeight, // End Point (Bottom of the dip)
    );

    // The "S-Curve" out of the notch
    path.cubicTo(
      centerX + (notchWidth /3),
      notchHeight, // Control Point 1
      centerX + (notchWidth / 4),
      0, // Control Point 2
      centerX + (notchWidth / 3) + 15,
      0, // End Point
    );

    // Line to top right corner
    path.lineTo(size.width - radius, 0);

    // Smooth corner for top right
    path.quadraticBezierTo(size.width, 0, size.width, radius);

    // Draw down to the bottom
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, radius);

    // Smooth corner for top left
    path.quadraticBezierTo(0, 0, radius, 0);

    // 3. Draw the path with the gradient paint
    canvas.drawPath(path, paint);

    // Optional: Fill the background of the bar so content doesn't show through
    final backgroundPaint = Paint()
      ..color =
          AppColors.lavender // Your dark background color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, backgroundPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
