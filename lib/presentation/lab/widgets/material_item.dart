import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MaterialItem extends StatelessWidget {
  final String name;
  final IconData icon;

  const MaterialItem({super.key, required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            color: AppColors.darkGray,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.lightBlue.withValues(alpha: 0.3),
            ),
          ),
          child: Icon(icon, color: AppColors.lightBlue, size: 28.sp),
        ),
        SizedBox(height: 8.h),
        Text(
          name,
          style: AppStyles.bold12whiteInter,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
