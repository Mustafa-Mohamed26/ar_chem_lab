import 'package:ar_chem_lab/core/constants/app_assets.dart';
import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_gradients.dart';
import 'package:ar_chem_lab/core/theme/app_padding.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/presentation/widget/gradient_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.screen,
      decoration: BoxDecoration(
        gradient: AppGradients.primary(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.midnightBlue, AppColors.royalBlue],
          stops: [0, 1.0],
        ),
      ),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.h),
            Row(
              children: [
                Image.asset(AppAssets.userImage),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("HAY MARK", style: AppStyles.bold20white),
                    Text(
                      "Ready for today's experiment?",
                      style: AppStyles.regular13skyBlue,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.h),
            GradientContainer(
              title: "Periodic Table",
              subtitle: "Explore all chemical elements visually",
              imagePath: AppAssets.atomImage,
              subImagePath: AppAssets.rightArrowImage,
              onTap: () {},
            ),
            SizedBox(height: 20.h),
            GradientContainer(
              title: "AI Suggestions",
              subtitle: "Personalized chemistry recommendations",
              imagePath: AppAssets.testTubeImage,
              subImagePath: AppAssets.rightArrowImage,
              onTap: () {},
            ),
            SizedBox(height: 20.h),
            Text("Most Viewed Elements", style: AppStyles.bold32white),
          ],
        ),
      ),
    );
  }
}
