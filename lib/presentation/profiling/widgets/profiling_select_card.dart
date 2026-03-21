import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';

/// A selectable list-style card for single-select options.
class ProfilingSelectCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const ProfilingSelectCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.darkBlue : AppColors.darkGray,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.lightBlue : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color.fromARGB(97, 123, 164, 247)
                    : AppColors.secondaryDarkGray,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.lightBlue : AppColors.lightGray,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppStyles.bold14whiteSecondary),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: AppStyles.regular12graySecondary,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // if (isSelected)
            //   Icon(Icons.check_circle, color: AppColors.lightBlue, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
