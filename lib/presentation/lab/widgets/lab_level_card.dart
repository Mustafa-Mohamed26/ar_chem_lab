import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/domain/entities/lab/lab_level_entity.dart';
import 'package:ar_chem_lab/presentation/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LabLevelCard extends StatelessWidget {
  final LabLevelEntity level;
  final VoidCallback onStart;

  const LabLevelCard({
    super.key,
    required this.level,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = level.status == LabLevelStatus.active;
    final bool isLocked = level.status == LabLevelStatus.locked;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      margin: EdgeInsets.only(bottom: 24.h),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isActive ? AppColors.lightBlue : AppColors.gray,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.lightBlue.withValues(alpha: 0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isActive ? AppColors.lightBlue.withValues(alpha: 0.3) : AppColors.gray,
                  ),
                ),
                child: Icon(
                  isLocked ? Icons.lock_outline : Icons.science_outlined,
                  color: isActive ? AppColors.lightBlue : AppColors.lightGray,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      level.title,
                      style: isActive ? AppStyles.bold18whiteOrbitron : AppStyles.bold18whiteOrbitron.copyWith(color: AppColors.lightGray),
                    ),
                    SizedBox(height: 4.h),
                    _buildStatusTag(isActive, isLocked),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            level.description,
            style: AppStyles.regular12interWhite.copyWith(color: AppColors.lightGray),
          ),
          SizedBox(height: 20.h),
          if (isActive) ...[
             _buildProgressBar(),
             SizedBox(height: 20.h),
             AppButton(
               text: "Start the Experiment", 
               onTap: onStart
             ),
          ] else if (isLocked) ...[
            _buildPrerequisiteBox(),
            SizedBox(height: 16.h),
            _buildLockedButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusTag(bool isActive, bool isLocked) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isActive ? AppColors.lightBlue.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isActive ? AppColors.lightBlue.withValues(alpha: 0.3) : AppColors.gray,
        ),
      ),
      child: Text(
        isActive ? "Active mission" : "Locked",
        style: TextStyle(
          fontSize: 10.sp,
          color: isActive ? AppColors.lightBlue : AppColors.lightGray,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: LinearProgressIndicator(
            value: level.progress,
            backgroundColor: AppColors.gray,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.lightBlue),
            minHeight: 8.h,
          ),
        ),
      ],
    );
  }

  Widget _buildPrerequisiteBox() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.gray, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.cyanAccent, size: 16.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              "Complete '${level.prerequisite ?? 'Prerequisites'}' to unlock",
              style: AppStyles.regular11interLightGray.copyWith(color: AppColors.lightGray),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockedButton() {
    return Container(
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.gray),
      ),
      child: Center(
        child: Text(
          "Level Restricted",
          style: TextStyle(
            color: AppColors.gray,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
