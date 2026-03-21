import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeActionCard extends StatelessWidget {
  final String title;
  final String description;
  final String iconPath;
  final IconData actionIcon;
  final VoidCallback onTap;

  const HomeActionCard({
    super.key,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.actionIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.darkGray,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.lightBlue, width: 2),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColors.lowSaturationWhite,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.lightBlue, width: 2),
              ),
              child: Image.asset(
                iconPath,
                width: 40.w,
                height: 40.w,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: AppStyles.bold18whiteOrbitron),
                  SizedBox(height: 4.h),
                  Text(description, style: AppStyles.regular12interWhite),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
                boxShadow: [],
              ),
              child: Icon(
                actionIcon,
                color: AppColors.midnightBlue,
                size: 24.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
