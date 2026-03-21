import 'package:ar_chem_lab/core/constants/app_assets.dart';
import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/presentation/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordChangedScreen extends StatelessWidget {
  const PasswordChangedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 38.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- SUCCESS IMAGE ---
              Image.asset(
                AppAssets.successMarkImage,
                width: 100.w,
                height: 100.w,
              ),
              SizedBox(height: 32.h),

              // --- HEADER SECTION ---
              _buildHeader(),
              SizedBox(height: 48.h),

              // --- ACTION BUTTON ---
              _buildBackToSignInButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          "Password Changed!",
          style: AppStyles.bold24whiteOrbitron,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        Text(
          "Your password has been changed successfully.",
          style: AppStyles.regular13interLightGray,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBackToSignInButton(BuildContext context) {
    return AppButton(
      text: "Back to sign In",
      onTap: () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.welcomeScreen,
          (route) => false,
        );
      },
    );
  }
}
