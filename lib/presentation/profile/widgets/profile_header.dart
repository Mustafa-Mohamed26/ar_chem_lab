import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/presentation/widget/app_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String rank;

  const ProfileHeader({super.key, required this.name, required this.rank});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Right Nav Button
        Align(alignment: Alignment.topRight, child: AppBackButton()),
        SizedBox(height: 10.h),
        // Profile Info
        Center(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2.w),
                ),
                child: ClipOval(
                  child: Icon(
                    Icons.person,
                    size: 80.sp,
                    color: AppColors.white,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(name, style: AppStyles.bold24whiteOrbitron),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.military_tech_outlined,
                    color: AppColors.lightBlue,
                    size: 22.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    rank,
                    style: AppStyles.semiBold12lightBlueInter.copyWith(
                      letterSpacing: 0.5,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
