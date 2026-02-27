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
    // Logic for Status Styles
    Color stateColor;
    String stateLabel;
    IconData stateIcon;

    switch (data.status) {
      case ExperimentStatus.completed:
        stateColor = AppColors.neonGreen; // Neon Green
        stateLabel = "Completed";
        stateIcon = Icons.check_circle_outline;
        break;
      case ExperimentStatus.inProgress:
        stateColor = AppColors.amber; // Orange/Amber
        stateLabel = "In Progress";
        stateIcon = Icons.error_outline;
        break;
      case ExperimentStatus.incomplete:
        stateColor = AppColors.redAccent;
        stateLabel = "Incomplete";
        stateIcon = Icons.highlight_off;
        break;
    }

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.lowSaturationWhite,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: stateColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  data.title,
                  style: AppStyles.bold24cyanAccentPrimary,
                ),
              ),
              Icon(stateIcon, color: stateColor, size: 28),
              SizedBox(width: 4.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: stateColor),
                ),
                child: Text(
                  stateLabel,
                  style: AppStyles.regular13skyBlueSecondary.copyWith(
                    color: stateColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.calendar_month, size: 18, color: AppColors.grey),
              SizedBox(width: 4.w),
              Text(data.date, style: AppStyles.regular12graySecondary),
              SizedBox(width: 12.w),
              Icon(Icons.timer, size: 18, color: AppColors.grey),
              SizedBox(width: 4.w),
              Text(data.duration, style: AppStyles.regular12graySecondary),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.mediumBlue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "Reactions",
                  style: AppStyles.regular10whiteSecondary,
                ),
              ),
              SizedBox(width: 10.w),
              Icon(Icons.info_outline, color: Colors.greenAccent, size: 16),
              Text(
                " Low risk",
                style: AppStyles.regular12graySecondary.copyWith(
                  color: AppColors.neonGreen,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            "Successfully observed pH change with indicator",
            style: AppStyles.regular12graySecondary,
          ),
          Row(
            children: [
              Icon(Icons.auto_graph, color: AppColors.cyanAccent, size: 16),
              Text(
                " pH: ${data.pHStart} - ${data.pHEnd}",
                style: AppStyles.regular12whiteSecondary,
              ),
              const Spacer(),
              SizedBox(width: 10.w),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                  size: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
