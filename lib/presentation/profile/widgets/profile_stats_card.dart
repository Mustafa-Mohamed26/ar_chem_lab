import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileStatsCard extends StatelessWidget {
  final int experimentsCount;
  final double labHours;
  final List<String> masteredTopics;

  const ProfileStatsCard({
    super.key,
    required this.experimentsCount,
    required this.labHours,
    required this.masteredTopics,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildStatItem(
                icon: Icons.check_circle_outline,
                label: "EXPERIMENTS",
                value: experimentsCount.toString(),
              ),
              SizedBox(width: 32.w),
              _buildStatItem(
                icon: Icons.access_time,
                label: "LAB HOURS",
                value: "${labHours}h",
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text("TOPICS MASTERED", style: AppStyles.bold12whiteInter),
          SizedBox(height: 16.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: masteredTopics
                  .map((topic) => _buildTopicChip(topic))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white70, size: 24.sp),
            SizedBox(width: 8.w),
            Text(label, style: AppStyles.bold12whiteInter),
          ],
        ),
        SizedBox(height: 8.h),
        Text(value, style: AppStyles.bold24whiteInter),
      ],
    );
  }

  Widget _buildTopicChip(String topic) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.lightBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.lightBlue.withValues(alpha: 0.2)),
      ),
      child: Text(topic, style: AppStyles.semiBold12lightBlueInter),
    );
  }
}
