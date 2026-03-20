import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExperimentStepItem extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String description;
  final bool isLast;

  const ExperimentStepItem({
    super.key,
    required this.stepNumber,
    required this.title,
    required this.description,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.lightBlue, width: 2),
                ),
                child: Center(
                  child: Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: const BoxDecoration(
                      color: Colors.transparent, // Empty dot for future "completed" state or keep it empty as per image
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2.w,
                    color: AppColors.gray,
                  ),
                ),
            ],
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.bold14interWhite,
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: AppStyles.regular11interLightGray,
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
