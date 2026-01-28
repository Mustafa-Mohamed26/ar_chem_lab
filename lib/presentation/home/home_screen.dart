import 'package:ar_chem_lab/core/constants/app_assets.dart';
import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_gradients.dart';
import 'package:ar_chem_lab/core/theme/app_padding.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/presentation/widget/gradient_bottom_nav_bar.dart';
import 'package:ar_chem_lab/presentation/widget/gradient_container.dart';
import 'package:ar_chem_lab/presentation/widget/user_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.primary(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.midnightBlue, AppColors.royalBlue],
          stops: [0, 1.0],
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: GradientBottomNavBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: AppPadding.screen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserHeader(
                  imageUrl: AppAssets.userImage,
                  title: "HAY MARK",
                  subtitle: "Ready for today's experiment?",
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
                Text("Most Viewed Elements", style: AppStyles.bold32whitePrimary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
