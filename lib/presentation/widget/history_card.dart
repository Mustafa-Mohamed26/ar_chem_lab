import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/presentation/history/experiment_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryCard extends StatelessWidget {
  final ExperimentData data;
  const HistoryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isSuccess = data.status == ExperimentStatus.success;
    final statusColor = isSuccess ? AppColors.lightBlue : AppColors.redAccent;
    final statusText = isSuccess ? "SUCCESS" : "FAILED";
    
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.lowSaturationGray),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Icon Container
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: isSuccess 
                  ? AppColors.lightBlue.withValues(alpha: 0.15)
                  : AppColors.redAccent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isSuccess 
                    ? AppColors.lightBlue.withValues(alpha: 0.3)
                    : AppColors.redAccent.withValues(alpha: 0.3),
              ),
            ),
            child: Icon(
              isSuccess ? Icons.science_outlined : Icons.error_outline,
              color: statusColor,
              size: 28.sp,
            ),
          ),
          SizedBox(width: 16.w),
          
          // Center Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data.title,
                      style: AppStyles.bold18whiteOrbitron.copyWith(
                        fontSize: 17.sp,
                      ),
                    ),
                    _buildStatusTag(statusText, statusColor),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  data.date,
                  style: AppStyles.regular12graySecondary.copyWith(
                    color: Colors.white38,
                  ),
                ),
                SizedBox(height: 12.h),
                _buildBottomInfo(isSuccess),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: AppStyles.bold10whitePrimary.copyWith(
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildBottomInfo(bool isSuccess) {
    if (isSuccess) {
      if (data.extraInfo != null) {
        return Row(
          children: [
            Icon(Icons.science, size: 14.sp, color: AppColors.cyanAccent),
            SizedBox(width: 6.w),
            Text(
              data.extraInfo!,
              style: AppStyles.bold12whiteSecondary.copyWith(
                color: Colors.white70,
                fontSize: 11.sp,
              ),
            ),
          ],
        );
      }
      return Row(
        children: [
          Icon(Icons.timer_outlined, size: 14.sp, color: AppColors.lightBlue),
          SizedBox(width: 6.w),
          Text(
            data.duration,
            style: AppStyles.medium12InterWhite.copyWith(
              color: Colors.white70,
              fontSize: 11.sp,
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Icon(Icons.warning_amber_rounded, size: 14.sp, color: AppColors.redAccent),
          SizedBox(width: 6.w),
          Text(
            "Reason: ${data.reason ?? 'Unknown'}",
            style: AppStyles.medium12InterWhite.copyWith(
              color: AppColors.redAccent.withValues(alpha: 0.8),
              fontSize: 11.sp,
            ),
          ),
        ],
      );
    }
  }
}
