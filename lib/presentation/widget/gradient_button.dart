import 'package:ar_chem_lab/core/constants/app_colors.dart';
import 'package:ar_chem_lab/core/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const GradientButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.electricBlue,
            AppColors.skyBlue,
            AppColors.skyBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.62, 1.0],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50.h,
          width: 235.w,
          decoration: BoxDecoration(
            color: AppColors.royalBlue,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 12.h),
          child: Center(
            child: Text(
              text,
              style: AppStyles.bold18white,
            ),
          ),
        ),
      ),
    );
  }
}
