import 'package:ar_chem_lab/core/constants/app_assets.dart';
import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientContainer extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imagePath;
  final String? subImagePath;
  final VoidCallback? onTap;
  const GradientContainer({
    super.key,
    required this.title,
    this.subtitle,
    this.imagePath,
    this.subImagePath,
    this.onTap,
  });

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
          height: 197.h,
          width: 343.w,
          decoration: BoxDecoration(
            color: AppColors.darkBlue,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: EdgeInsets.all(15.w),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: .center,
                  children: [
                    Text(title, style: AppStyles.bold35white),
                    Text(subtitle ?? "", style: AppStyles.regular18white),
                  ],
                ),
              ),
              Column(
                children: [
                  Image.asset(imagePath ?? ""),
                  Image.asset(subImagePath ?? ""),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
