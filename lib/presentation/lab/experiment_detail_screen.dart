import 'package:ar_chem_lab/core/constants/app_assets.dart';
import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/domain/entities/lab/experiment_entity.dart';
import 'package:ar_chem_lab/presentation/lab/widgets/experiment_step_item.dart';
import 'package:ar_chem_lab/presentation/lab/widgets/material_item.dart';
import 'package:ar_chem_lab/presentation/widget/app_button.dart';
import 'package:ar_chem_lab/presentation/widget/app_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExperimentDetailScreen extends StatelessWidget {
  final ExperimentEntity experiment;

  const ExperimentDetailScreen({super.key, required this.experiment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(AppAssets.appLogo, height: 46.h),
                        SizedBox(width: 8.w),
                        Text(
                          "${_getExperienceLevel(experiment)} experiment",
                          style: AppStyles.bold18whiteOrbitron,
                        ),
                      ],
                    ),
                    const AppBackButton(),
                  ],
                ),
              ),
              _buildMainCard(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 32.h),
                    Text(
                      "Required Materials",
                      style: AppStyles.bold20whiteOrbitron,
                    ),
                    SizedBox(height: 24.h),
                    _buildMaterialsGrid(),
                    SizedBox(height: 32.h),
                    Text(
                      "Experiment Path",
                      style: AppStyles.bold20whiteOrbitron,
                    ),
                    SizedBox(height: 24.h),
                    AppButton(text: "Start the Experiment", onTap: () {}),
                    SizedBox(height: 24.h),
                    ...experiment.path.asMap().entries.map((entry) {
                      return ExperimentStepItem(
                        stepNumber: entry.key + 1,
                        title: entry.value.title,
                        description: entry.value.description,
                        isLast: entry.key == experiment.path.length - 1,
                      );
                    }),
                    if (experiment.tip != null) ...[
                      SizedBox(height: 32.h),
                      _buildTipBox(),
                    ],
                    SizedBox(height: 48.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainCard() {
    return Container(
      margin: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.lightBlue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            child: Container(
              height: 200.h,
              width: double.infinity,
              color: AppColors.gray,
              child: const Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 64,
                  color: AppColors.lightGray,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(experiment.title, style: AppStyles.bold18whiteOrbitron),
                SizedBox(height: 8.h),
                Text(
                  experiment.description,
                  style: AppStyles.regular13interLightGray,
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStat(Icons.access_time, "TIME", experiment.time),
                    _buildStat(
                      Icons.auto_awesome_outlined,
                      "EXP",
                      experiment.exp,
                    ),
                    _buildStat(
                      Icons.security,
                      "SAFETY",
                      experiment.safety.name.toUpperCase(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String label, String value) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.lightBlue, size: 16.sp),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                color: AppColors.lightBlue,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(value, style: AppStyles.bold12whiteInter),
      ],
    );
  }

  Widget _buildMaterialsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 16.w,
        childAspectRatio: 0.7,
      ),
      itemCount: experiment.materials.length,
      itemBuilder: (context, index) {
        final material = experiment.materials[index];
        return MaterialItem(
          name: material.name,
          icon: _getMaterialIcon(material.icon),
        );
      },
    );
  }

  Widget _buildTipBox() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.lightBlue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.lightBlue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.lightBlue, size: 18.sp),
              SizedBox(width: 8.w),
              Text(
                "Pro tip : AR Calibration",
                style: AppStyles.bold14interWhite,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(experiment.tip!, style: AppStyles.regular11interLightGray),
        ],
      ),
    );
  }

  String _getExperienceLevel(ExperimentEntity experiment) {
    // Logic to determine level from metadata or pass it in
    return "Beginner";
  }

  IconData _getMaterialIcon(String iconName) {
    switch (iconName) {
      case "beaker":
        return Icons.science;
      case "pipette":
        return Icons.colorize;
      case "testTube":
        return Icons.biotech;
      case "heat":
        return Icons.whatshot;
      default:
        return Icons.category;
    }
  }
}
