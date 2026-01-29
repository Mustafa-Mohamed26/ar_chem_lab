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
      padding: EdgeInsets.all(2.w),
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
            borderRadius: BorderRadius.circular(26),
          ),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: .center,
                  children: [
                    Text(title, style: AppStyles.bold40whitePrimary),
                    Text(subtitle ?? "", style: AppStyles.regular18whiteSecondary),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(imagePath ?? "",),
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
