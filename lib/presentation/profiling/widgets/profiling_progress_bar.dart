import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ar_chem_lab/core/theme/app_colors.dart';

/// A progress bar widget displaying "STEP X OF 4" with a filled bar.
class ProfilingProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String label;

  const ProfilingProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentStep / totalSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'STEP $currentStep OF $totalSteps',
              style: TextStyle(
                fontFamily: 'NirmalaUI',
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.lightBlue,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontFamily: 'NirmalaUI',
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.lightBlue,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.darkGray,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.lightBlue),
            minHeight: 4.h,
          ),
        ),
      ],
    );
  }
}
