import 'package:ar_chem_lab/core/constants/app_assets.dart';
import 'package:ar_chem_lab/core/routes/app_routes.dart';
import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/presentation/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildHeaderSection()),
            _buildBottomSection(context),
          ],
        ),
      ),
    );
  }

  // ------------------- Section: Header (Logo & Text) -------------------
  Widget _buildHeaderSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppAssets.appLogo, height: 160.h, fit: BoxFit.contain),
          Text(
            'Start Your Chemistry Journey',
            textAlign: TextAlign.center,
            style: AppStyles.bold29lightBlueOrbitron,
          ),
          SizedBox(height: 24.h),
          Text(
            'Explore the molecular world through augmented reality. Safe, interactive, and immersive learning \nat your fingertips.',
            textAlign: TextAlign.center,
            style: AppStyles.bold13interWhite,
          ),
        ],
      ),
    );
  }

  // ------------------- Section: Bottom Sheet -------------------
  Widget _buildBottomSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 52.w, vertical: 32.h),
      decoration: BoxDecoration(
        color: AppColors.gray,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.r),
          topRight: Radius.circular(40.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAuthButtons(context),
          SizedBox(height: 24.h),
          _buildDivider(),
          SizedBox(height: 24.h),
          _buildGuestAccess(context),
          SizedBox(height: 24.h),
          _buildDisclaimer(),
        ],
      ),
    );
  }

  // ------------------- Components -------------------

  /// Sign In and Create Account buttons
  Widget _buildAuthButtons(BuildContext context) {
    return Column(
      children: [
        AppButton(
          text: 'Sign In',
          onTap: () => Navigator.pushNamed(context, AppRoutes.loginScreen),
        ),
        SizedBox(height: 16.h),
        AppButton(
          text: 'Create Account',
          backgroundColor: AppColors.darkGray,
          textColor: AppColors.white,
          borderColor: AppColors.secondaryDarkGray,
          onTap: () => Navigator.pushNamed(context, AppRoutes.registerScreen),
        ),
      ],
    );
  }

  /// Divider with "OR" text
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.secondaryDarkGray)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text('OR', style: AppStyles.regular13interLightGray),
        ),
        Expanded(child: Divider(color: AppColors.secondaryDarkGray)),
      ],
    );
  }

  /// Guest access link
  Widget _buildGuestAccess(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.homeScreen,
        (route) => false,
      ),
      child: Text(
        'Continue as Guest',
        style: AppStyles.semiBold14lightBlueInter,
      ),
    );
  }

  /// Legal disclaimer text
  Widget _buildDisclaimer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Text(
        'By continuing, you agree to our Terms of Service and Privacy Policy.',
        textAlign: TextAlign.center,
        style: AppStyles.regular10whiteSecondary.copyWith(
          color: AppColors.lightGray,
        ),
      ),
    );
  }
}
