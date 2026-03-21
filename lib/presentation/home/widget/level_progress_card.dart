import 'package:ar_chem_lab/core/constants/app_assets.dart';
import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/presentation/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LevelProgressCard extends StatelessWidget {
  final String level;
  final double progress; // 0.0 to 1.0
  final String helperText;
  final VoidCallback onContinue;

  const LevelProgressCard({
    super.key,
    required this.level,
    required this.progress,
    required this.helperText,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: AppColors.lightBlue,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(level, style: AppStyles.bold32whiteOrbitron),
                  SizedBox(height: 10.h),
                ],
              ),
              Positioned(
                right: -90.w,
                top: -40.h,
                child: Image.asset(
                  AppAssets.testTubeImage,
                  height: 110.h,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Text(
            '"$helperText"',
            style: AppStyles.regular11interLightGray.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 20.h),
          AppButton(text: "Continue", onTap: onContinue),
        ],
      ),
    );
  }
}
