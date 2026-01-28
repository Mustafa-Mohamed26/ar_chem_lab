import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/presentation/widget/circular_gradients_painter.dart';
import 'package:ar_chem_lab/presentation/widget/notch_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientBottomNavBar extends StatelessWidget {
  const GradientBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.h, // Increased height to accommodate the elevated button
      color: AppColors.transparent,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // --- PART 1: The Nav Bar with Notch and Gradient Border ---
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width.w, 80.h),
            painter: NotchPainter(), // Drawing the notched border
            child: Container(
              height: 85.h,
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  navItem(icon: Icons.history, label: "History", onTap: () {}),
                  navItem(icon: Icons.auto_awesome, label: "Chatbot", onTap: () {}),
                ],
              ),
            ),
          ),

          // --- PART 2: The Floating Action Button with Gradient Border ---
          Positioned(
            top: 1, // Lifts the button out of the bar
            child: GestureDetector(
              onTap: () {},
              child: CustomPaint(
                painter: CircleGradientPainter(), // Drawing the button's border
                child: Container(
                  width: 60.w,
                  height: 60.h,
                  margin: const EdgeInsets.all(
                    2,
                  ), // Padding between border and icon
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.lavender, // Match the bar background
                  ),
                  child: const Icon(
                    Icons.science,
                    color: AppColors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),

          // Labels for the center button (optional)
          Positioned(
            bottom: 10,
            child: Text("My Lab", style: AppStyles.bold14white),
          ),
        ],
      ),
    );
  }

  Widget navItem({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap,
      child: SizedBox(
        width: 90.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.white, size: 40.sp),
            Text(label, style: AppStyles.medium12white),
          ],
        ),
      ),
    );
  }
}
